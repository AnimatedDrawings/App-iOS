//
//  CombineNotifier.swift
//  Presentation_Shared
//
//  Created by minii on 2023/09/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Combine
import SwiftUI

public actor CombineNotifier<Output: Equatable> {
  private let subject: CurrentValueSubject<Output, Never>
  var cancellables: [UUID: AnyCancellable] = [:]
  
  public nonisolated let initialValue: Output
  
  public init(initialValue: Output) {
    self.subject = CurrentValueSubject<Output, Never>(initialValue)
    self.initialValue = initialValue
  }
  
  public func set(_ newValue: Output) {
    subject.value = newValue
  }
  
  public func get() -> Output {
    subject.value
  }
  
  public func values() -> AsyncStream<Output> {
    AsyncStream { continuation in
      let id = UUID()
      
      cancellables[id] = subject
        .removeDuplicates()
        .sink { _ in
        continuation.finish()
      } receiveValue: { value in
        continuation.yield(value)
      }
      
      continuation.onTermination = { _ in
        Task { await self.cancel(id) }
      }
    }
  }
  
  private func cancel(_ id: UUID) {
    cancellables[id] = nil
  }
}

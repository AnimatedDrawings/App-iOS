//
//  GlobalNotifier.swift
//  SharedProvider
//
//  Created by chminii on 3/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Combine
import Foundation

public actor GlobalNotifier<Output: Equatable> {
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
  
  public func values(id: UUID = UUID()) -> AsyncStream<Output> {
    AsyncStream { continuation in
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

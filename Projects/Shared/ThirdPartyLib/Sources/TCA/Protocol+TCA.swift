//
//  Extension+TCA.swift
//  ThirdPartyLib
//
//  Created by minii on 2023/09/14.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public protocol ADUI: View {
  associatedtype MyFeature: Reducer
  associatedtype MyViewStore = ViewStoreOf<MyFeature>
  associatedtype MyStore = StoreOf<MyFeature>
}

public typealias TaskEmptyResult = TaskResult<TaskEmptyResultValue>

public struct TaskEmptyResultValue: Equatable, Sendable {
  public init() {}
}

public extension TaskResult {
  static func empty(
    _ body: @Sendable () async throws -> ()
  ) async -> TaskResult<TaskEmptyResultValue> where Success == TaskEmptyResultValue {
    do {
      try await body()
      return .success(TaskEmptyResultValue())
    } catch {
      return .failure(error)
    }
  }
}

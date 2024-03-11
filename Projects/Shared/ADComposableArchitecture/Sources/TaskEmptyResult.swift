//
//  TaskEmptyResult.swift
//  ADComposableArchitecture
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

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

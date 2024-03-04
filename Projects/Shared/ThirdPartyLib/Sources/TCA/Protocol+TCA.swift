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

public extension ViewStore {
  func action(_ action: ViewAction) -> (() -> Void) {
    return { self.send(action) }
  }
}

public extension Store {
  func action(_ action: Action) -> (() -> Void) {
    return { self.send(action) }
  }
}

// NOTE: view 에서 사용되는 Action 을 정의합니다.
public protocol ViewAction {
  associatedtype ViewActions
  
  static func view(_: ViewActions) -> Self
}

// NOTE: 그 외 Reducer 내부적으로 사용되는 Action 을 정의합니다.
public protocol InnerAction {
  associatedtype InnerActions
  
  static func inner(_: InnerActions) -> Self
}

// NOTE: 비동기적으로 돌아가는 Action 을 정의합니다.
public protocol AsyncAction {
  associatedtype AsyncActions
  
  static func async(_: AsyncActions) -> Self
}

// NOTE: 자식 Redcuer 에서 사용되는 Action 을 정의합니다.
public protocol ScopeAction {
  associatedtype ScopeActions
  
  static func scope(_: ScopeActions) -> Self
}

// NOTE: 부모 Reducer 에서 사용되는 Action 을 정의합니다.
public protocol DelegateAction {
  associatedtype DelegateActions
  
  static func delegate(_: DelegateActions) -> Self
}

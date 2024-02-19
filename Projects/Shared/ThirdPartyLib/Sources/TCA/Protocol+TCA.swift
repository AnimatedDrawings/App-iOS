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

//public protocol FeatureAction {
//  associatedtype ViewAction
//  associatedtype InnerAction
//  associatedtype AsyncAction
//  associatedtype ScopeAction
//  associatedtype DelegateAction
//  
//  // NOTE: view 에서 사용되는 Action 을 정의합니다.
//  static func view(_: ViewAction) -> Self
//  
//  // NOTE: 그 외 Reducer 내부적으로 사용되는 Action 을 정의합니다.
//  static func inner(_: InnerAction) -> Self
//  
//  // NOTE: 비동기적으로 돌아가는 Action 을 정의합니다.
//  static func async(_: AsyncAction) -> Self
//  
//  // NOTE: 자식 Redcuer 에서 사용되는 Action 을 정의합니다.
//  static func scope(_: ScopeAction) -> Self
//  
//  // NOTE: 부모 Reducer 에서 사용되는 Action 을 정의합니다.
//  static func delegate(_: DelegateAction) -> Self
//}

public protocol ViewActions {
  associatedtype ViewAction
  
  static func view(_: ViewAction) -> Self
}

public protocol InnerActions {
  associatedtype InnerAction
  
  static func inner(_: InnerAction) -> Self
}

public protocol AsyncActions {
  associatedtype AsyncAction
  
  static func async(_: AsyncAction) -> Self
}

public protocol ScopeActions {
  associatedtype ScopeAction
  
  static func scope(_: ScopeAction) -> Self
}

public protocol DelegateActions {
  associatedtype DelegateAction
  
  static func delegate(_: DelegateAction) -> Self
}

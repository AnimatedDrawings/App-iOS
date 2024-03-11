//
//  Action.swift
//  ADComposableArchitecture
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

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

// NOTE: Store에서 SharedValue를 업데이트하는 Action 을 정의합니다.
public protocol UpdateAction {
  associatedtype UpdateActions
  
  static func update(_: UpdateActions) -> Self
}

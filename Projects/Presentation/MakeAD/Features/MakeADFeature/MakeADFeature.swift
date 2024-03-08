//
//  MakeADFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UploadADrawingFeatures
import FindingTheCharacterFeatures
import SharedProvider

@Reducer
public struct MakeADFeature {
  @Dependency(StepProvider.self) var step
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ScopeReducer()
    UpdateReducer()
    ViewReducer()
  }
}

public extension MakeADFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ScopeAction, UpdateAction, ViewAction {
    case binding(BindingAction<State>)
    case scope(ScopeActions)
    case update(UpdateActions)
    case view(ViewActions)
  }
  
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      default:
        return .none
      }
    }
  }
}

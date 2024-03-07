//
//  UploadADrawingFeature.swift
//  UploadADrawingExample
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import NetworkProvider
import SharedProvider
import ImageTools

@Reducer
public struct UploadADrawingFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.imageCompressor) var imageCompressor
  @Dependency(\.shared.stepBar) var stepBar
  @Dependency(\.shared.ad_id) var ad_id
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    InnerReducer()
    AsyncReducer()
    DelegateReducer()
    UpdateReducer()
  }
}

public extension UploadADrawingFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ViewAction, InnerAction, AsyncAction, DelegateAction, UpdateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case inner(InnerActions)
    case async(AsyncActions)
    case delegate(DelegateActions)
    case update(UpdateActions)
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

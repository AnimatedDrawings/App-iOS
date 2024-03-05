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
  @Dependency(\.adInfo) var adInfo
  @Dependency(\.imageCompressor) var imageCompressor
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    InnerReducer()
    AsyncReducer()
    DelegateReducer()
  }
}

public extension UploadADrawingFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ViewAction, InnerAction, AsyncAction, DelegateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case inner(InnerActions)
    case async(AsyncActions)
    case delegate(DelegateActions)
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

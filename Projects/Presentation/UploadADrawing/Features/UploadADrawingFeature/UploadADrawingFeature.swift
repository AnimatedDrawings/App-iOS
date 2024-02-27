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
import ImageCompressor

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
  enum Action: Equatable, BindableAction, ViewActions, InnerActions, AsyncActions, DelegateActions {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case delegate(DelegateAction)
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

//
//  UploadADrawingMainAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import NetworkProvider
import SharedProvider

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
  enum Action: Equatable, BindableAction, ViewActions, InnerActions, AsyncActions, DelegateActions {
    case binding(BindingAction<State>)
    
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case delegate(DelegateAction)
  }
}

extension UploadADrawingFeature {
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

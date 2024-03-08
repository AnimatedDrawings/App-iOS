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
  @Dependency(StepProvider.self) var step
  @Dependency(\.adInfo.id) var ad_id
  
  public var body: some ReducerOf<Self> {
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
  
  func MainReducer() -> some ReducerOf<Self> {
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
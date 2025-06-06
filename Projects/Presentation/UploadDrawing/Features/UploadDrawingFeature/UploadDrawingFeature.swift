//
//  UploadDrawingFeature.swift
//  UploadDrawingExample
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkProvider
import SharedProvider
import ImageTools

@Reducer
public struct UploadDrawingFeature: Reducer {
  public init() {}
  
  @Dependency(ADNetworkProvider.self) var makeADProvider
  @Dependency(ImageCompressor.self) var imageCompressor
  @Dependency(StepProvider.self) var step
  @Dependency(ADInfoProvider.self) var adInfo
  
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

public extension UploadDrawingFeature {
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

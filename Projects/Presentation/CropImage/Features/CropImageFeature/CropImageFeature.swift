//
//  CropImageFeature.swift
//  CropImageFeatures
//
//  Created by chminii on 1/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit
import ImageTools

@Reducer
public struct CropImageFeature {
  @Dependency(ImageCropper.self) var imageCropper
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    DelegateReducer()
  }
}

public extension CropImageFeature {
  enum Action: Equatable, BindableAction, ViewAction, DelegateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case delegate(DelegateActions)
  }
}

extension CropImageFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case.binding:
        return .none
      default:
        return .none
      }
    }
  }
}
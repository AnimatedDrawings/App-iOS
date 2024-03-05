//
//  FindingTheCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI
import SharedProvider
import DomainModel
import NetworkProvider
import CropImageFeatures

@Reducer
public struct FindingTheCharacterFeature {
  public init() {}

  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.adInfo) var adInfo
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    InnerReducer()
    AsyncReducer()
    ScopeReducer()
    DelegateReducer()
  }
}

public extension FindingTheCharacterFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ViewAction, InnerAction, AsyncAction, ScopeAction, DelegateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case inner(InnerActions)
    case async(AsyncActions)
    case scope(ScopeActions)
    case delegate(DelegateActions)
    
    case cropImage(CropImageFeature.Action)
  }
}

extension FindingTheCharacterFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
//      case .findTheCharacter:
//        guard state.cropImage.croppedImage != nil else {
//          return .none
//        }
//        let croppedCGRect = state.cropImage.croppedCGRect
//        
//        return .run { send in
//          guard let ad_id = await makeAD.ad_id.get() else { return }
//          await send(.setLoadingView(true))
//          await send(
//            .findTheCharacterResponse(
//              TaskResult.empty {
//                try await makeADProvider.findTheCharacter(ad_id, croppedCGRect)
//              }
//            )
//          )
//        }
//        
//      case .findTheCharacterResponse(.success):
//        return .send(.downloadMaskImage)
//        
//      case .findTheCharacterResponse(.failure(let error)):
//        print(error)
//        state.isSuccessUpload = false
//        return .run { send in
//          await send(.setLoadingView(false))
//          await send(.showNetworkErrorAlert)
//        }
//        
//      case .downloadMaskImage:
//        return .run { send in
//          guard let ad_id = await makeAD.ad_id.get() else { return }
//          await send(
//            .downloadMaskImageResponse(
//              TaskResult {
//                try await makeADProvider.downloadMaskImage(ad_id)
//              }
//            )
//          )
//        }
//        
//      case .downloadMaskImageResponse(.success(let maskImage)):
//        state.isSuccessUpload = true
//        return .run { send in
//          await makeAD.initMaskImage.set(maskImage)
//          await send(.setLoadingView(false))
//          await send(.toggleCropImageView)
//        }
//        
//      case .downloadMaskImageResponse(.failure(let error)):
//        print(error)
//        state.isSuccessUpload = false
//        return .run { send in
//          await send(.setLoadingView(false))
//          await send(.showNetworkErrorAlert)
//        }
        
//      case .onDismissCropImageView:
//        if state.isSuccessUpload {
//          state.isSuccessUpload = false
//          return .run { _ in
//            await stepBar.currentStep.set(.SeparatingCharacter)
//            await stepBar.isShowStepStatusBar.set(true)
//            await stepBar.completeStep.set(.FindingTheCharacter)
//          }
//        }
//        return .none
        
      default:
        return .none
      }
    }
  }
}

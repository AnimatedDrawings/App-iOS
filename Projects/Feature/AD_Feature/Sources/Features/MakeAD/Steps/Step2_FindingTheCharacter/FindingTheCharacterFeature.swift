//
//  FindingTheCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct FindingTheCharacterFeature: Reducer {
  @Dependency(\.makeADClient) var makeADClient
  
  public init() {}
  public typealias State = TCABaseState<FindingTheCharacterFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState = false
    @BindingState public var isShowCropImageView = false
    
    public var isShowLoadingView = false
    
    var tmpCroppedImage: UIImage = .init()
    var tmpBoundingBoxDTO: BoundingBoxDTO = .init()
    var isSuccessUpload = false
    
    @BindingState public var isShowAlert = false
    public var titleAlert = ""
    public var descriptionAlert = ""
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case bindIsShowStepStatusBar(Bool)
    
    case checkAction
    case toggleCropImageView
    case findTheCharacter(UIImage?, CGRect)
    case findTheCharacterResponse(TaskResult<EmptyResponse>)
    case setLoadingView(Bool)
    case onDismissCropImageView
    
    case downloadMaskImage
    case downloadMaskImageResponse(TaskResult<UIImage>)
    
    case showAlert(ADError)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .bindIsShowStepStatusBar(let flag):
        state.sharedState.isShowStepStatusBar = flag
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
        
      case .toggleCropImageView:
        state.isShowCropImageView.toggle()
        return .none
        
      case .setLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case let .findTheCharacter(croppedUIImage, croppedCGRect):
        guard let ad_id = state.sharedState.ad_id,
              let croppedUIImage = croppedUIImage
        else {
          return .none
        }
        let boundingBoxDTO = croppedCGRect.toBoundingBoxDTO
        state.tmpCroppedImage = croppedUIImage
        state.tmpBoundingBoxDTO = boundingBoxDTO
        
        let findTheCharacterRequest = FindTheCharacterRequest(
          ad_id: ad_id,
          boundingBoxDTO: boundingBoxDTO
        )
        
        return .run { send in
          await send(.setLoadingView(true))
          await send(
            .findTheCharacterResponse(
              TaskResult {
                try await makeADClient.step2FindTheCharacter(findTheCharacterRequest)
              }
            )
          )
        }
        
      case .findTheCharacterResponse(.success):
        return .send(.downloadMaskImage)
        
      case .findTheCharacterResponse(.failure(let error)):
        print(error)
        let adError = error as? ADError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlert(adError))
        }
        
      case .onDismissCropImageView:
        if state.isSuccessUpload {
          state.sharedState.completeStep = .SeparatingCharacter
          state.sharedState.currentStep = .SeparatingCharacter
          state.sharedState.isShowStepStatusBar = true
          state.isSuccessUpload = false
        }
        return .none
        
      case .downloadMaskImage:
        guard let ad_id = state.sharedState.ad_id else {
          return .none
        }
        return .run { send in
          await send(
            .downloadMaskImageResponse(
              TaskResult {
                try await makeADClient.step2DownloadMaskImage(ad_id)
              }
            )
          )
        }
        
      case .downloadMaskImageResponse(.success(let maskImage)):
        state.sharedState.croppedImage = state.tmpCroppedImage
        state.sharedState.boundingBoxDTO = state.tmpBoundingBoxDTO
        state.sharedState.initMaskImage = maskImage
        state.isSuccessUpload = true
        return .run { send in
          await send(.setLoadingView(false))
          await send(.toggleCropImageView)
        }
        
      case .downloadMaskImageResponse(.failure(let error)):
        print(error)
        let adError = error as? ADError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlert(adError))
        }
        
      case .showAlert(let adError):
        state.titleAlert = adError.title
        state.descriptionAlert = adError.description
        state.isShowAlert.toggle()
        return .none
      }
    }
  }
}

extension CGRect {
  var toBoundingBoxDTO: BoundingBoxDTO {
    let top = Int(self.origin.y)
    let bottom = top + Int(self.height)
    let left = Int(self.origin.x)
    let right = left + Int(self.width)
    
    return BoundingBoxDTO(top: top, bottom: bottom, left: left, right: right)
  }
}

//
//  ConfigureAnimationFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import Photos
import LocalFileProvider
import SharedProvider
import Domain_Model
import NetworkProvider

public struct ConfigureAnimationFeature: Reducer {
  @Dependency(\.configureAnimationProvider) var configureAnimationProvider
  @Dependency(\.shared.stepBar) var stepBar
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.adViewCase) var adViewCase
  
  public init() {}
  
  public struct State: Equatable {
    public init() {}
    
    @BindingState public var isShowAnimationListView = false
    public var isShowLoadingView = false
    @BindingState public var isShowShareView = false
    @BindingState public var isShowActionSheet = false
    
    public var selectedAnimation: ADAnimation? = nil
    public var myAnimationData: Data? = nil
    public var myAnimationURL: URL? = nil
    public var cache: [ADAnimation : URL?] = initCache()
    
    var isSuccessAddAnimation = false
    
    @PresentationState public var alertShared: AlertState<AlertShared>? = nil
    @PresentationState public var alertTrashMakeAD: AlertState<AlertTrashMakeAD>? = nil
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    case fixMakeAD
    
    case toggleIsShowAnimationListView
    case toggleIsShowShareView
    case toggleIsShowShareActionSheet
    
    case setLoadingView(Bool)
    
    case selectAnimation(ADAnimation)
    case addAnimationResponse(TaskResult<Void>)
    
    case downloadVideo
    case downloadVideoResponse(TaskResult<Data>)
    
    case saveGIFInPhotos(URL)
    
    case onDismissAnimationListView
    
    case addToCache(URL)
    
    case showAlertShared(AlertState<AlertShared>)
    case showAlertTrashMakeAD
    
    case alertShared(PresentationAction<AlertShared>)
    case alertTrashMakeAD(PresentationAction<AlertTrashMakeAD>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
      .ifLet(\.$alertTrashMakeAD, action: /Action.alertTrashMakeAD)
  }
}

extension ConfigureAnimationFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .fixMakeAD:
        return .run { _ in
          await adViewCase.set(.MakeAD)
        }
        
      case .toggleIsShowAnimationListView:
        state.isShowAnimationListView.toggle()
        return .none

      case .toggleIsShowShareView:
        state.isShowShareView.toggle()
        return .none
        
      case .toggleIsShowShareActionSheet:
        if state.myAnimationURL == nil {
          return .send(.showAlertShared(initAlertShareAction()))
        }
        state.isShowActionSheet.toggle()
        return .none
        
      case .setLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case .selectAnimation(let animation):
        state.selectedAnimation = animation
        if let tmpGifURLInCache = state.cache[animation],
           let gifURLInCache = tmpGifURLInCache
        {
          state.isSuccessAddAnimation = true
          return .send(.toggleIsShowAnimationListView)
        }
        
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else {
            return
          }
          
          await send(.setLoadingView(true))
          await send(
            .addAnimationResponse(
              TaskResult {
                try await configureAnimationProvider.add(ad_id, animation)
              }
            )
          )
        }
        
      case .addAnimationResponse(.success):
        return .send(.downloadVideo)
        
      case .addAnimationResponse(.failure(let error)):
        print(error)
//        let adError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(true))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .downloadVideo:
        guard let selectedAnimation = state.selectedAnimation else {
          return .none
        }
        
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else {
            return
          }
          
          await send(
            .downloadVideoResponse(
              TaskResult {
                try await configureAnimationProvider.download(ad_id, selectedAnimation)
              }
            )
          )
        }
        
      case .downloadVideoResponse(.success(let response)):
        guard let gifURL = try? LF.save(with: response) else {
          return .none
        }
        
        return .run { send in
          await send(.addToCache(gifURL))
          await send(.setLoadingView(false))
          await send(.toggleIsShowAnimationListView)
        }
        
      case .downloadVideoResponse(.failure(let error)):
        print(error)
//        let adError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .onDismissAnimationListView:
        if state.isSuccessAddAnimation {
          guard let selectedAnimation = state.selectedAnimation,
                let tmpGifURLInCache = state.cache[selectedAnimation],
                let gifURLInCache = tmpGifURLInCache,
                let dataFromURL: Data = try? LF.read(with: gifURLInCache)
          else {
            return .none
          }
          
          state.myAnimationData = dataFromURL
          state.myAnimationURL = gifURLInCache
          state.isSuccessAddAnimation = false
        }
        return .none
        
      case .addToCache(let gifURL):
        guard let selectedAnimation = state.selectedAnimation else {
          return .none
        }
        state.cache[selectedAnimation] = gifURL
        print(gifURL.path())
        state.isSuccessAddAnimation = true
        return .none
        
      case .saveGIFInPhotos(let gifURL):
        return .run(
          operation: { send in
            try await PHPhotoLibrary.shared().performChanges {
              let request = PHAssetCreationRequest.forAsset()
              request.addResource(with: .photo, fileURL: gifURL, options: nil)
            }
            await send(.showAlertShared(initAlertSaveGIFInPhotosResult(isSuccess: true)))
          },
          catch: { error, send in
            await send(.showAlertShared(initAlertSaveGIFInPhotosResult(isSuccess: false)))
          }
        )
        
      case .showAlertShared(let alertState):
        state.alertShared = alertState
        return .none
      case .showAlertTrashMakeAD:
        state.alertTrashMakeAD = initAlertTrashMakeAD()
        return .none
      case .alertShared:
        return .none
      case .alertTrashMakeAD(.presented(.trash)):
        state.selectedAnimation = nil
        state.myAnimationData = nil
        state.myAnimationURL = nil
        
        return .run { _ in
          await makeAD.ad_id.set(nil)
          await makeAD.originalImage.set(nil)
          await makeAD.boundingBox.set(nil)
          await makeAD.initMaskImage.set(nil)
          await makeAD.croppedImage.set(nil)
          await makeAD.maskedImage.set(nil)
          await makeAD.joints.set(nil)
          await adViewCase.set(.MakeAD)
          
          await stepBar.completeStep.set(.None)
          await stepBar.currentStep.set(.UploadADrawing)
          await stepBar.isShowStepStatusBar.set(true)
        }
        
      case .alertTrashMakeAD:
        return .none
      }
    }
  }
}

extension ConfigureAnimationFeature {
  public enum AlertShared: Equatable {}
  public enum AlertTrashMakeAD: Equatable {
    case trash
  }
  
  func initAlertNetworkError() -> AlertState<AlertShared> {
    return AlertState(
      title: {
        TextState("Connection Error")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("Please check device network condition.")
      }
    )
  }
  
  func initAlertSaveGIFInPhotosResult(isSuccess: Bool) -> AlertState<AlertShared> {
    let title = isSuccess ? "Save Success!" : "Save GIF Error"
    let description = isSuccess ? "" : "Cannot Save GIF.."

    return AlertState(
      title: {
        TextState(title)
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState(description)
      }
    )
  }
  
  func initAlertShareAction() -> AlertState<AlertShared> {
    return AlertState(
      title: {
        TextState("No Animated Drawings File")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("The file does not exist. Make a Animation First")
      }
    )
  }
  
  func initAlertTrashMakeAD() -> AlertState<AlertTrashMakeAD> {
    return AlertState<AlertTrashMakeAD>(
      title: {
        TextState("Reset Animated Drawing")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
        ButtonState(action: .trash) {
          TextState("Reset")
            .foregroundColor(.red)
        }
      },
      message: {
        TextState("Are you sure to reset making animation all step?")
      }
    )
  }
}

extension ConfigureAnimationFeature.State {
  static func initCache() -> [ADAnimation : URL?] {
    return ADAnimation.allCases
      .reduce(into: [ADAnimation : URL?]()) { dict, key in
        dict[key] = nil
      }
  }
}

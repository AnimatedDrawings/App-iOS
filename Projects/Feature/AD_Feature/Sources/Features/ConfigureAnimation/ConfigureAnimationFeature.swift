//
//  ConfigureAnimationFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Photos

public struct ConfigureAnimationFeature: Reducer {
  @Dependency(\.configureAnimationClient) var configureAnimationClient
  
  public init() {}
  
  public typealias State = TCABaseState<ConfigureAnimationFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var isShowAnimationListView = false
    public var isShowLoadingView = false
    @BindingState public var isShowShareView = false
    @BindingState public var isShowActionSheet = false
    
    public var selectedAnimation: ADAnimation? = nil
    public var myAnimationData: Data? = nil
    public var myAnimationURL: URL? = nil
    public var cache: [ADAnimation : URL?] = ADAnimation.allCases
      .reduce(into: [ADAnimation : URL?]()) { dict, key in
        dict[key] = nil
      }
    var isSuccessAddAnimation = false
    
    @PresentationState public var alertShared: AlertState<AlertShared>?
    @PresentationState public var alertTrashMakeAD: AlertState<AlertTrashMakeAD>?
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case toggleIsShowAnimationListView
    case toggleIsShowAddAnimationView
    case toggleIsShowShareView
    case toggleIsShowShareActionSheet
    
    case setLoadingView(Bool)
    
    case selectAnimation(ADAnimation)
    case addAnimationResponse(TaskResult<EmptyResponse>)
    
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
        
      case .toggleIsShowAnimationListView:
        state.isShowAnimationListView.toggle()
        return .none
      case .toggleIsShowAddAnimationView:
        state.sharedState.isShowAddAnimationView.toggle()
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
        
        guard let ad_id = state.sharedState.ad_id else {
          return .none
        }
        
        let request = ConfigureAnimationRequest(
          ad_id: ad_id,
          adAnimationDTO: .init(adAnimation: animation)
        )
        
        return .run { send in
          await send(.setLoadingView(true))
          await send(
            .addAnimationResponse(
              TaskResult {
                try await configureAnimationClient.add(request)
              }
            )
          )
        }
        
      case .addAnimationResponse(.success):
        return .send(.downloadVideo)
        
      case .addAnimationResponse(.failure(let error)):
        print(error)
        let adError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(true))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .downloadVideo:
        guard let ad_id = state.sharedState.ad_id,
              let selectedAnimation = state.selectedAnimation
        else {
          return .none
        }
        
        let request = ConfigureAnimationRequest(
          ad_id: ad_id,
          adAnimationDTO: .init(adAnimation: selectedAnimation)
        )
        
        return .run { send in
          await send(
            .downloadVideoResponse(
              TaskResult {
                try await configureAnimationClient.downloadVideo(request)
              }
            )
          )
        }
        
      case .downloadVideoResponse(.success(let response)):
        guard let gifURL = try? ADFileManager.shared.save(with: response) else {
          return .none
        }
        
        return .run { send in
          await send(.addToCache(gifURL))
          await send(.setLoadingView(false))
          await send(.toggleIsShowAnimationListView)
        }
        
      case .downloadVideoResponse(.failure(let error)):
        print(error)
        let adError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .onDismissAnimationListView:
        if state.isSuccessAddAnimation {
          guard let selectedAnimation = state.selectedAnimation,
                let tmpGifURLInCache = state.cache[selectedAnimation],
                let gifURLInCache = tmpGifURLInCache,
                let dataFromURL: Data = try? ADFileManager.shared.read(with: gifURLInCache)
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
        state.sharedState = SharedState()
        return .none
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
        }
      },
      message: {
        TextState("Are you sure to reset making animation all step?")
      }
    )
  }
}

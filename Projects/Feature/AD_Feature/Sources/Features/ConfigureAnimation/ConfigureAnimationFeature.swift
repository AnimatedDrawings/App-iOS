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
    
    @BindingState public var isShowAlert = false
    public var titleAlert = ""
    public var descriptionAlert = ""
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case toggleIsShowAnimationListView
    case toggleIsShowAddAnimationView
    case toggleIsShowShareView
    case toggleIsShowActionSheet
    
    case setLoadingView(Bool)
    
    case selectAnimation(ADAnimation)
    case addAnimationResponse(TaskResult<EmptyResponse>)
    
    case downloadVideo
    case downloadVideoResponse(TaskResult<Data>)
    
    case saveGIFInCameraRoll(URL)
    
    case onDismissAnimationListView
    
    case addToCache(URL)
    
    case showAlert(ADMoyaError)
    case saveGIFResultAlert(Bool)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    
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
        
      case .toggleIsShowActionSheet:
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
          await send(.showAlert(adError))
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
          await send(.showAlert(adError))
        }
        
      case .onDismissAnimationListView:
        if state.isSuccessAddAnimation {
          guard let selectedAnimation = state.selectedAnimation,
                let tmpGifURLInCache = state.cache[selectedAnimation],
                let gifURLInCache = tmpGifURLInCache
          else {
            return .none
          }
          
          guard let dataFromURL: Data = try? ADFileManager.shared.read(with: gifURLInCache) else {
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
        
      case .showAlert(let adError):
        state.titleAlert = adError.title
        state.descriptionAlert = adError.description
        state.isShowAlert.toggle()
        return .none
        
      case .saveGIFInCameraRoll(let gifURL):
        return .run(
          operation: { send in
            try await PHPhotoLibrary.shared().performChanges {
              let request = PHAssetCreationRequest.forAsset()
              request.addResource(with: .photo, fileURL: gifURL, options: nil)
            }
            await send(.saveGIFResultAlert(true))
          },
          catch: { error, send in
            await send(.saveGIFResultAlert(false))
          }
        )
        
      case .saveGIFResultAlert(let isSuccess):
        let titleAlert = isSuccess ? "Save Success!" : "Save GIF Error"
        let descriptionAlert = isSuccess ? "" : "Cannot Save GIF.."
        state.titleAlert = titleAlert
        state.descriptionAlert = descriptionAlert
        state.isShowAlert.toggle()
        return .none
      }
    }
  }
}




//PHPhotoLibrary.shared().performChanges({
//    let request = PHAssetCreationRequest.forAsset()
//    request.addResource(with: .photo, fileURL: 'YOUR_GIF_URL', options: nil)
//}) { (success, error) in
//    if let error = error {
//        print(error.localizedDescription)
//    } else {
//        print("GIF has saved")
//    }
//}

//
//  ConfigureAnimationFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import Photos
import LocalFileProvider
import SharedProvider
import DomainModels
import NetworkProvider

public struct ConfigureAnimationFeature: Reducer {
  @Dependency(\.configureAnimationProvider) var configureAnimationProvider
  @Dependency(\.shared.stepBar) var stepBar
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.adViewState.currentView) var currentView
  @Dependency(\.localFileProvider) var localFileProvider
  
  public init() {}
  
  public struct State: Equatable {
    @BindingState public var isShowAnimationListView = false
    public var isShowLoadingView = false
    @BindingState public var isShowShareView = false
    @BindingState public var isShowActionSheet = false
    
    public var selectedAnimation: ADAnimation? = nil
    public var myAnimationData: Data? = nil
    public var myAnimationURL: URL? = nil
    public var cache: [ADAnimation : URL?] = initCache()
    
    var isSuccessAddAnimation = false
    
    @BindingState public var isShowNetworkErrorAlert: Bool
    @BindingState public var isShowNoAnimationFileAlert: Bool
    @BindingState public var isShowSaveGIFInPhotosResultAlert: Bool
    public var saveGIFInPhotosResult: Bool
    @BindingState public var isShowTrashMakeADAlert: Bool
    
    public init(
      isShowAnimationListView: Bool = false,
      isShowLoadingView: Bool = false,
      isShowShareView: Bool = false,
      isShowActionSheet: Bool = false,
      selectedAnimation: ADAnimation? = nil,
      myAnimationData: Data? = nil,
      myAnimationURL: URL? = nil,
      cache: [ADAnimation : URL?] = initCache(),
      isSuccessAddAnimation: Bool = false,
      isShowNetworkErrorAlert: Bool = false,
      isShowNoAnimationFileAlert: Bool = false,
      isShowSaveGIFInPhotosResultAlert: Bool = false,
      saveGIFInPhotosResult: Bool = false,
      isShowTrashMakeADAlert: Bool = false
    ) {
      self.isShowAnimationListView = isShowAnimationListView
      self.isShowLoadingView = isShowLoadingView
      self.isShowShareView = isShowShareView
      self.isShowActionSheet = isShowActionSheet
      self.selectedAnimation = selectedAnimation
      self.myAnimationData = myAnimationData
      self.myAnimationURL = myAnimationURL
      self.cache = cache
      self.isSuccessAddAnimation = isSuccessAddAnimation
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
      self.isShowNoAnimationFileAlert = isShowNoAnimationFileAlert
      self.isShowSaveGIFInPhotosResultAlert = isShowSaveGIFInPhotosResultAlert
      self.saveGIFInPhotosResult = saveGIFInPhotosResult
      self.isShowTrashMakeADAlert = isShowTrashMakeADAlert
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case fixMakeAD
    
    case toggleIsShowAnimationListView
    case toggleIsShowShareView
    case toggleIsShowShareActionSheet
    
    case setLoadingView(Bool)
    
    case selectAnimation(ADAnimation)
    case addAnimationResponse(TaskEmptyResult)
    
    case downloadVideo
    case downloadVideoResponse(TaskResult<Data>)
    
    case saveGIFInPhotos(URL)
    
    case onDismissAnimationListView
    
    case addToCache(URL)
    
    case resetMakeADData
    
    case showNetworkErrorAlert
    case showNoAnimationFileAlert
    case showSaveGIFInPhotosResultAlert(Bool)
    case showTrashMakeADAlert
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
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
          await currentView.set(.MakeAD)
        }
        
      case .toggleIsShowAnimationListView:
        state.isShowAnimationListView.toggle()
        return .none

      case .toggleIsShowShareView:
        state.isShowShareView.toggle()
        return .none
        
      case .toggleIsShowShareActionSheet:
        if state.myAnimationURL == nil {
          return .send(.showNoAnimationFileAlert)
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
              TaskResult.empty {
                try await configureAnimationProvider.add(ad_id, animation)
              }
            )
          )
        }
        
      case .addAnimationResponse(.success):
        return .send(.downloadVideo)
        
      case .addAnimationResponse(.failure(let error)):
        print(error)
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
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
        guard let gifURL = try? localFileProvider.save(response, "gif") else {
          return .none
        }
        
        return .run { send in
          await send(.addToCache(gifURL))
          await send(.setLoadingView(false))
          await send(.toggleIsShowAnimationListView)
        }
        
      case .downloadVideoResponse(.failure(let error)):
        print(error)
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
        }
        
      case .onDismissAnimationListView:
        if state.isSuccessAddAnimation {
          guard let selectedAnimation = state.selectedAnimation,
                let tmpGifURLInCache = state.cache[selectedAnimation],
                let gifURLInCache = tmpGifURLInCache,
                let dataFromURL: Data = try? localFileProvider.read(gifURLInCache)
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
            await send(.showSaveGIFInPhotosResultAlert(true))
          },
          catch: { error, send in
            await send(.showSaveGIFInPhotosResultAlert(false))
          }
        )
        
      case .showNetworkErrorAlert:
        state.isShowNetworkErrorAlert.toggle()
        return .none
        
      case .showNoAnimationFileAlert:
        state.isShowNoAnimationFileAlert.toggle()
        return .none
        
      case .showSaveGIFInPhotosResultAlert(let result):
        state.saveGIFInPhotosResult = result
        state.isShowSaveGIFInPhotosResultAlert.toggle()
        return .none
        
      case .showTrashMakeADAlert:
        state.isShowTrashMakeADAlert.toggle()
        return .none
        
      case .resetMakeADData:
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
          await currentView.set(.MakeAD)
          
          await stepBar.completeStep.set(.None)
          await stepBar.currentStep.set(.UploadADrawing)
          await stepBar.isShowStepBar.set(true)
        }
      }
    }
  }
}

public extension ConfigureAnimationFeature.State {
  static func initCache() -> [ADAnimation : URL?] {
    return ADAnimation.allCases
      .reduce(into: [ADAnimation : URL?]()) { dict, key in
        dict[key] = nil
      }
  }
}

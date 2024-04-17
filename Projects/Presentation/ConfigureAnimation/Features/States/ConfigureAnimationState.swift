//
//  ConfigureAnimationState.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import Foundation

public extension ConfigureAnimationFeature {
  @ObservableState
  struct State: Equatable {
    public var isShowAnimationListView = false
    public var isShowLoadingView = false
    public var isShowShareView = false
    public var isShowActionSheet = false
    
    public var selectedAnimation: ADAnimation? = nil
    public var myAnimationData: Data? = nil
    public var myAnimationURL: URL? = nil
    public var cache: [ADAnimation : URL?] = initCache()
    
    var isSuccessAddAnimation = false
    
    public var isShowNetworkErrorAlert: Bool
    public var isShowNoAnimationFileAlert: Bool
    public var isShowSaveGIFInPhotosResultAlert: Bool
    
    public var isShowTrashMakeADAlert: Bool
    
    
    public var alert: Alert
    
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
      isShowTrashMakeADAlert: Bool = false,
      
      alert: Alert = .init()
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
      self.isShowTrashMakeADAlert = isShowTrashMakeADAlert
      
      
      self.alert = alert
    }
  }
  
  @ObservableState
  struct Alert: Equatable {
    public var trash: Bool
    public var saveGif: SaveGifAlertState
    public var noAnimation: Bool
    
    public init(
      trash: Bool = false,
      saveGif: SaveGifAlertState = .init(),
      noAnimation: Bool = false
    ) {
      self.trash = trash
      self.saveGif = saveGif
      self.noAnimation = noAnimation
    }
  }
  
  @ObservableState
  struct SaveGifAlertState: Equatable {
    public var toggle: Bool
    public var isSuccess: Bool
    
    public init(
      toggle: Bool = false,
      isSuccess: Bool = false
    ) {
      self.toggle = toggle
      self.isSuccess = isSuccess
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

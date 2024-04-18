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
    
    
    
    
    public var currentAnimation: ADAnimationFile?
    
    public var trash: ConfigureAnimationFeature.Trash
    public var share: ConfigureAnimationFeature.Share
    
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
      
      
      currentAnimation: ADAnimationFile? = nil,
      
      trash: ConfigureAnimationFeature.Trash = .init(),
      share: ConfigureAnimationFeature.Share = .init()
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
      
      
      
      self.currentAnimation = currentAnimation
      self.trash = trash
      self.share = share
    }
  }
}

public extension ConfigureAnimationFeature {
  @ObservableState
  struct Trash: Equatable {
    public var alert: Bool
    
    public init(
      alert: Bool = false
    ) {
      self.alert = alert
    }
  }
}

public extension ConfigureAnimationFeature {
  @ObservableState
  struct Share: Equatable {
    public var saveResult: SaveResult
    public var alertNoAnimation: Bool
    public var sheetShare: Bool
    public var sheetShareFile: Bool
    
    public init(
      saveResult: SaveResult = .init(),
      alertNoAnimation: Bool = false,
      sheetShare: Bool = false,
      sheetShareFile: Bool = false
    ) {
      self.saveResult = saveResult
      self.alertNoAnimation = alertNoAnimation
      self.sheetShare = sheetShare
      self.sheetShareFile = sheetShareFile
    }
  }
  
  @ObservableState
  struct SaveResult: Equatable {
    public var alert: Bool
    public var isSuccess: Bool
    
    public init(
      alert: Bool = false,
      isSuccess: Bool = false
    ) {
      self.alert = alert
      self.isSuccess = isSuccess
    }
  }
}

public extension ConfigureAnimationFeature {
  @ObservableState
  struct ADAnimationFile: Equatable {
    public var data: Data
    public var url: URL
    
    public init(
      data: Data = .init(),
      url: URL = .init(filePath: "")
    ) {
      self.data = data
      self.url = url
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

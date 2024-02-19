//
//  UploadADrawingFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI
import NetworkProvider
import SharedProvider
import DomainModel
import NetworkStorage
import ADUIKitSources

public struct UploadADrawingFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.adInfo) var adInfo
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    InnerReducer()
    asyncReducer()
  }
}

public extension UploadADrawingFeature {
  struct State: Equatable {
    public var stepBar: StepBarState
    
    public var checkState: CheckState
    public var isActiveUploadButton: Bool
    
    public var isShowLoadingView: Bool
    @BindingState public var isShowNetworkErrorAlert: Bool
    @BindingState public var isShowFindCharacterErrorAlert: Bool
    @BindingState public var isShowImageSizeErrorAlert: Bool
    
    public init(
      stepBar: StepBarState = .init(),
      checkState: CheckState = .init(),
      isEnableUploadButton: Bool = false,
      isShowLoadingView: Bool = false,
      isShowNetworkErrorAlert: Bool = false,
      isShowFindCharacterErrorAlert: Bool = false,
      isShowImageSizeErrorAlert: Bool = false
    ) {
      self.stepBar = stepBar
      self.checkState = checkState
      self.isActiveUploadButton = isEnableUploadButton
      self.isShowLoadingView = isShowLoadingView
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
      self.isShowFindCharacterErrorAlert = isShowFindCharacterErrorAlert
      self.isShowImageSizeErrorAlert = isShowImageSizeErrorAlert
    }
  }
  
  struct CheckState: Equatable {
    public var check1: Bool
    public var check2: Bool
    public var check3: Bool
    public var check4: Bool
    
    public init(
      check1: Bool = false,
      check2: Bool = false,
      check3: Bool = false,
      check4: Bool = false
    ) {
      self.check1 = check1
      self.check2 = check2
      self.check3 = check3
      self.check4 = check4
    }
  }
}

public extension UploadADrawingFeature {
  enum Action: Equatable, BindableAction, ViewActions, InnerActions, AsyncActions {
    case binding(BindingAction<State>)
    
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
  }
}

public extension UploadADrawingFeature {
  enum ViewAction: Equatable {
    case check(Check)
    case uploadDrawing(Data?)
    case initState
  }
  
  enum Check: Equatable {
    case list1
    case list2
    case list3
    case list4
  }
  
  func ViewReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
        switch viewAction {
          
        case .check(let checkList):
          switch checkList {
          case .list1:
            state.checkState.check1.toggle()
          case .list2:
            state.checkState.check2.toggle()
          case .list3:
            state.checkState.check3.toggle()
          case .list4:
            state.checkState.check4.toggle()
          }
          activeUploadButton(state: &state)
          return .none
          
        case .uploadDrawing(let imageData):
          return .send(.async(.uploadDrawing(imageData)))
          
        case .initState:
          state = State()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
  
  func activeUploadButton(state: inout State) {
    if state.checkState.check1 && state.checkState.check2
        && state.checkState.check3 && state.checkState.check4
    {
      state.isActiveUploadButton = true
    } else {
      state.isActiveUploadButton = false
    }
  }
}

public extension UploadADrawingFeature {
  enum InnerAction: Equatable {
    case setLoadingView(Bool)
    case moveToFindingTheCharacter
    
    case showNetworkErrorAlert
    case showFindCharacterErrorAlert
    case showImageSizeErrorAlert
  }
  
  func InnerReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .inner(let innerAction):
        switch innerAction {
        case .setLoadingView(let flag):
          state.isShowLoadingView = flag
          return .none
          
        case .moveToFindingTheCharacter:
          state.stepBar = StepBarState(
            isShowStepBar: true,
            currentStep: .FindingTheCharacter,
            completeStep: .UploadADrawing
          )
          return .none
          
        case .showNetworkErrorAlert:
          state.isShowNetworkErrorAlert.toggle()
          return .none
          
        case .showFindCharacterErrorAlert:
          state.isShowFindCharacterErrorAlert.toggle()
          return .none
          
        case .showImageSizeErrorAlert:
          state.isShowImageSizeErrorAlert.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
}

public extension UploadADrawingFeature {
  enum AsyncAction: Equatable {
    case uploadDrawing(Data?)
    case uploadDrawingResponse(TaskResult<UploadDrawingResult>)
  }
  
  func asyncReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .async(let asyncAction):
        switch asyncAction {
        case .uploadDrawing(let imageData):
          guard let compressResult = compressImage(imageData: imageData) else {
            return .send(.inner(.showImageSizeErrorAlert))
          }
          let compressedData: Data = compressResult.0
          let originalImage: UIImage = compressResult.1
          
          return .run { send in
            await makeAD.originalImage.set(originalImage)
            await send(.inner(.setLoadingView(true)))
            await send(
              .async(
                .uploadDrawingResponse(
                  TaskResult {
                    try await makeADProvider.uploadDrawing(compressedData)
                  }
                )
              )
            )
          }
          
        case .uploadDrawingResponse(.success(let result)):
          return .run { send in
            await adInfo.id.set(result.ad_id)
            await makeAD.boundingBox.set(result.boundingBox)
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.moveToFindingTheCharacter))
          }
          
        case .uploadDrawingResponse(.failure(let error)):
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            if let error = error as? NetworkError,
               error == .ADServerError
            {
              await send(.inner(.showFindCharacterErrorAlert))
            } else {
              await send(.inner(.showNetworkErrorAlert))
            }
          }
        }
      default:
        return .none
      }
    }
  }
  
  func compressImage(imageData: Data?) -> (Data, UIImage)? {
    guard let imageData = imageData,
          let originalImage = UIImage(data: imageData)
    else {
      return nil
    }
    
    let maxKB: Double = 3000
    let originalSize = imageData.getSize(.kilobyte)
    if originalSize > 10000 {
      return nil
    }
    
    guard let compressedData: Data = originalSize < maxKB ?
            imageData :
              originalImage.reduceFileSize(maxKB: maxKB),
          let tmpOriginalImage = UIImage(data: compressedData)
    else {
      return nil
    }
    
    return (compressedData, tmpOriginalImage)
  }
}

extension UploadADrawingFeature {
  func MainReducer() -> some Reducer<State, Action> {
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

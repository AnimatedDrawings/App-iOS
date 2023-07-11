//
//  FindingTheCharacterStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct FindingTheCharacterStore: ReducerProtocol {
  @Dependency(\.adClient) var adClient
  
  public init() {}
  public typealias State = TCABaseState<FindingTheCharacterStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState = false
    
    @BindingState public var isShowCropImageView = false
    @BindingState public var croppedImage: UIImage? = nil
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case checkAction
    case showCropImageView
    case uploadImage
    case uploadImageResponse(TaskResult<String>)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
        
      case .showCropImageView:
        state.isShowCropImageView = true
        return .none
        
      case .uploadImage:
        guard let croppedImage = state.croppedImage else {
          print("No CroppedImage")
          return .none
        }
        
        state.sharedState.curStep = .SeparatingCharacter
        
        return .none
//        return .task {
//          await .uploadImageResponse(
//            TaskResult {
//              let response = try await adClient.uploadImage(croppedImage)
//              return response
//            }
//          )
//        }
        
      case .uploadImageResponse(.success(let response)):
        print("Upload Image Success : \(response)")
        return .none
        
      case .uploadImageResponse(.failure(let error)):
        print("Upload Image Fail : \(error)")
        return .none
      }
    }
  }
}

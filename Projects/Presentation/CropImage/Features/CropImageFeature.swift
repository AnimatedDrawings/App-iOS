//
//  CropImageFeature.swift
//  CropImageFeatures
//
//  Created by chminii on 1/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit
import SharedProvider

@Reducer
public struct CropImageFeature {
  @Dependency(\.shared.makeAD.originalImage) var originalImage
  @Dependency(\.shared.makeAD.boundingBox) var boundingBox
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
  }
}

public extension CropImageFeature {
  struct State: Equatable {
    public var resetTrigger: Bool
    public var croppedImage: UIImage?
    public var croppedCGRect: CGRect
    @BindingState public var boundingBoxInfo: BoundingBoxInfo
    
    public init(
      resetTrigger: Bool = false,
      originalImage: UIImage = .init(),
      croppedImage: UIImage? = nil,
      croppedCGRect: CGRect = .init(),
      boundingBoxInfo: BoundingBoxInfo = .init()
    ) {
      self.resetTrigger = resetTrigger
      self.croppedImage = croppedImage
      self.croppedCGRect = croppedCGRect
      self.boundingBoxInfo = boundingBoxInfo
    }
  }
  
  struct BoundingBoxInfo: Equatable {
    public var imageScale: CGFloat
    public var curRect: CGRect
    public var croppedRect: CGRect
    public var viewSize: CGRect
    
    public init(
      imageScale: CGFloat = 0,
      curRect: CGRect = .init(),
      croppedRect: CGRect = .init(),
      viewSize: CGRect = .init()
    ) {
      self.imageScale = imageScale
      self.curRect = curRect
      self.croppedRect = croppedRect
      self.viewSize = viewSize
    }
  }
}

public extension CropImageFeature {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case save
    case crop(UIImage)
    case cancel
    case reset
    
    case initViewSize(CGRect)
    case initImageScale(CGFloat)
    case setImageScale(CGFloat, CGRect)
  }
}

extension CropImageFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .save:
        return .run { send in
          guard let originalImage = await originalImage.get() else {
            return
          }
          await send(.crop(originalImage))
        }
        
      case .crop(let originalImage):
        let reciprocal: CGFloat = 1 / state.boundingBoxInfo.imageScale
        
        let cropCGSize = CGSize(
          width: state.boundingBoxInfo.croppedRect.size.width * reciprocal,
          height: state.boundingBoxInfo.croppedRect.size.height * reciprocal
        )
        
        let cropCGPoint = CGPoint(
          x: -state.boundingBoxInfo.croppedRect.origin.x * reciprocal,
          y: -state.boundingBoxInfo.croppedRect.origin.y * reciprocal
        )
        
        UIGraphicsBeginImageContext(cropCGSize)
        
        originalImage.draw(at: cropCGPoint)
        state.croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        state.croppedCGRect = state.boundingBoxInfo.croppedRect.scale(1 / state.boundingBoxInfo.imageScale)
        
        return .none
        
      case .cancel:
        return .none
        
      case .reset:
        state.resetTrigger.toggle()
        return .none
        
      case .initViewSize(let viewSize):
        state.boundingBoxInfo.viewSize = viewSize
        return .none
        
      case .initImageScale(let imageScale):
        return .run { send in
          guard let boundingBox = await boundingBox.get() else {
            return
          }
          await send(.setImageScale(imageScale, boundingBox))
        }
        
      case let .setImageScale(imageScale, boundingBox):
        state.boundingBoxInfo.imageScale = imageScale
        let imageArea = boundingBox.scale(imageScale)
        state.boundingBoxInfo.curRect = imageArea
        state.boundingBoxInfo.croppedRect = imageArea
        return .none
      }
    }
  }
}

extension CGRect {
  func scale(_ imageScale: CGFloat) -> CGRect {
    let x: CGFloat = self.origin.x * imageScale
    let y: CGFloat = self.origin.y * imageScale
    let width: CGFloat = self.size.width * imageScale
    let height: CGFloat = self.size.height * imageScale
    
    return CGRect(x: x, y: y, width: width, height: height)
  }
}

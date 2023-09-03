//
//  SharedState.swift
//  AD_Feature
//
//  Created by minii on 2023/06/15.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct SharedState: Equatable {
  public init() {}
  
  public var isShowStepStatusBar = true
  public var currentStep: Step = .UploadADrawing
  public var completeStep: Step = .None
  
  public var ad_id: String? = nil
  public var originalImage: UIImage? = nil
  public var boundingBoxDTO: BoundingBoxDTO? = nil
  public var initMaskImage: UIImage? = nil
  public var croppedImage: UIImage? = nil
  public var maskedImage: UIImage? = nil
  public var jointsDTO: JointsDTO? = nil
  
  public var isShowConfigureAnimationView = false
}

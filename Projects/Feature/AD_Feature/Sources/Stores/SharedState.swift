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
  
  @BindingState public var curStep: Step = .UploadADrawing
  public var originalImage: UIImage? = nil
  @BindingState public var croppedImage: UIImage? = nil
}

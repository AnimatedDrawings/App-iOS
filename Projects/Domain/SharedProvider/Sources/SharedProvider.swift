//
//  SharedProvider.swift
//  SharedProvider
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import SharedStorage
import DomainModel
import UIKit
import ComposableArchitecture

public struct Shared {
  public let makeAD = Self.MakeAD()
  public let stepBar = Self.StepBar()
  public var adViewCase = CombineNotifier<ADViewCase>(initialValue: .OnBoarding)
}

public extension Shared {
  struct StepBar {
    public let isShowStepStatusBar = CombineNotifier<Bool>(initialValue: true)
    public let currentStep = CombineNotifier<Step>(initialValue: .UploadADrawing)
    public let completeStep = CombineNotifier<Step>(initialValue: .None)
  }
  
  struct MakeAD {
    public let ad_id = CombineNotifier<String?>(initialValue: nil)
    public let originalImage = CombineNotifier<UIImage?>(initialValue: nil)
    public let boundingBox = CombineNotifier<CGRect?>(initialValue: nil)
    public let initMaskImage = CombineNotifier<UIImage?>(initialValue: nil)
    public let croppedImage = CombineNotifier<UIImage?>(initialValue: nil)
    public let maskedImage = CombineNotifier<UIImage?>(initialValue: nil)
    public let joints = CombineNotifier<Joints?>(initialValue: nil)
  }
}

extension Shared: DependencyKey {
  public static var liveValue = Shared()
}

public extension DependencyValues {
  var shared: Shared {
    get { self[Shared.self] }
    set { self[Shared.self] = newValue }
  }
}

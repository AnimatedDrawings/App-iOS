//
//  SharedProvider.swift
//  SharedProvider
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import DomainModel
import UIKit
import ADComposableArchitecture

public struct Shared {
  public var ad_id: CombineNotifier<String?>
  public var makeAD: Self.MakeAD
  public var stepBar: Self.StepBar
  public var adViewCase: CombineNotifier<ADViewCase>
  
  public init(
    ad_id: String? = nil,
    makeAD: Self.MakeAD = Self.MakeAD(),
    stepBar: Self.StepBar = Self.StepBar(),
    adViewCase: ADViewCase = .OnBoarding
  ) {
    self.ad_id = CombineNotifier(initialValue: ad_id)
    self.makeAD = makeAD
    self.stepBar = stepBar
    self.adViewCase = .init(initialValue: adViewCase)
  }
}

public extension Shared {
  struct StepBar {
    public var isShowStepBar: CombineNotifier<Bool>
    public var currentStep: CombineNotifier<MakeADStep>
    public var completeStep: CombineNotifier<MakeADStep>
    
    public init(
      isShowStepBar: Bool = true,
      currentStep: MakeADStep = .UploadADrawing,
      completeStep: MakeADStep = .None
    ) {
      self.isShowStepBar = .init(initialValue: isShowStepBar)
      self.currentStep = .init(initialValue: currentStep)
      self.completeStep = .init(initialValue: completeStep)
    }
  }
  
  struct MakeAD {
    public var ad_id: CombineNotifier<String?>
    public var originalImage: CombineNotifier<UIImage?>
    public var boundingBox: CombineNotifier<CGRect?>
    public var initMaskImage: CombineNotifier<UIImage?>
    public var croppedImage: CombineNotifier<UIImage?>
    public var maskedImage: CombineNotifier<UIImage?>
    public var joints: CombineNotifier<Joints?>
    
    public init(
      ad_id: String? = nil,
      originalImage: UIImage? = nil,
      boundingBox: CGRect? = nil,
      initMaskImage: UIImage? = nil,
      croppedImage: UIImage? = nil,
      maskedImage: UIImage? = nil,
      joints: Joints? = nil
    ) {
      self.ad_id = .init(initialValue: ad_id)
      self.originalImage = .init(initialValue: originalImage)
      self.boundingBox = .init(initialValue: boundingBox)
      self.initMaskImage = .init(initialValue: initMaskImage)
      self.croppedImage = .init(initialValue: croppedImage)
      self.maskedImage = .init(initialValue: maskedImage)
      self.joints = .init(initialValue: joints)
    }
  }
}

extension Shared: DependencyKey {
  public static var liveValue = Shared()
  public static var testValue = Shared(
    makeAD: MakeAD(
      ad_id: "test",
      originalImage: UIImage(),
      boundingBox: CGRect(),
      initMaskImage: UIImage(),
      croppedImage: UIImage(),
      maskedImage: UIImage(),
      joints: Joints.mockData()
    )
  )
}

public extension DependencyValues {
  var shared: Shared {
    get { self[Shared.self] }
    set { self[Shared.self] = newValue }
  }
}

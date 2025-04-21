//
//  MockRootView.swift
//  RootExample
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkProvider
import RootFeatures
import SharedProvider
import SwiftUI
import MakeADFeatures
import ADUIKit
import DomainModels
import ADResources


extension MakeADFeature.State {
  public static func example1() -> Self {
    let example1 = ADResourcesAsset.Example1TestImages.self
    
    return .init(
      step: .init(
        isShowStepBar: true,
        currentStep: .FindCharacterJoints,
        completeStep: .FindCharacterJoints
      ),
      makeADInfo: .init(
        originalImage: example1.e1OriginImage.image,
        boundingBox: BoundingBox.example1().cgRect,
        initMaskImage: example1.e1Mask.image,
        croppedImage: example1.e1Texture.image,
        maskedImage: example1.e1CutoutCharacterImage.image,
        joints: Joints.example1()
      ),
      uploadDrawing: .init(),
      findTheCharacter: .init(),
      separateCharacter: .init(),
      findCharacterJoints: .init()
    )
  }
}

struct MockRootView: View {
  @Bindable var store: StoreOf<RootFeature>

  init() {
    let state = RootFeature.State(
      adViewState: .ConfigureAnimation,
      makeAD: .example1(),
      configureAnimation: .init()
    )
    store = Store(initialState: state) {
      RootFeature()
        .dependency(ADViewStateProvider(currentView: .ConfigureAnimation))
        .dependency(ADInfoProvider(id: "example1"))
        .dependency(\.adNetworkProvider, ADNetworkProvider.testValue)
    }
  }

  var body: some View {
    RootView(store: store)
  }
}

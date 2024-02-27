//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import DomainModel
import UploadADrawing
import FindingTheCharacter
import SeparatingCharacter
import FindingCharacterJoints
import ThirdPartyLib
import MakeADFeatures

public struct MakeADView: View {
  @Perception.Bindable var store: StoreOf<MakeADFeature>
  
  public init(
    store: StoreOf<MakeADFeature> = Store(initialState: .init()) {
      MakeADFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    GeometryReader { geo in
      List {
        // if -> ishidden 사용
        if store.stepBar.isShowStepBar {
          StepBar(
            currentStep: store.stepBar.currentStep,
            completeStep: store.stepBar.completeStep
          )
        }
        
        PageTabView(store: store)
          .frame(height: geo.size.height + geo.safeAreaInsets.bottom)
      }
      .listStyle(.plain)
      .addADBackground(with: store.stepBar.currentStep)
      .scrollContentBackground(.hidden)
      .animation(.default, value: store.stepBar.isShowStepBar)
    }
    .fullScreenOverlayPresentationSpace(.named("UploadADrawingView"))
  }
}

private extension MakeADView {
  struct PageTabView: View {
    @Perception.Bindable var store: StoreOf<MakeADFeature>
    
    var body: some View {
      TabView(selection: $store.stepBar.currentStep) {
        UploadADrawingView(
          store: store.scope(
            state: \.uploadADrawing,
            action: \.scope.uploadADrawing
          )
        )
        .tag(Step.UploadADrawing)
        
        FindingTheCharacterView()
          .tag(Step.FindingTheCharacter)
        
        SeparatingCharacterView()
          .tag(Step.SeparatingCharacter)
        
        FindingCharacterJointsView()
          .tag(Step.FindingCharacterJoints)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .ignoresSafeArea()
      .listRowSeparator(.hidden)
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
      .listRowBackground(Color.clear)
    }
  }
}

#Preview {
  MakeADView()
}

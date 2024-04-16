//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import DomainModels
import UploadDrawing
import FindTheCharacter
import SeparateCharacter
import FindCharacterJoints
import ADComposableArchitecture
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
      WithPerceptionTracking {
        List {
          // if -> ishidden 사용
          if store.step.isShowStepBar {
            StepBar(
              currentStep: store.step.currentStep,
              completeStep: store.step.completeStep
            )
          }
          
          PageTabView(store: store)
            .frame(height: geo.size.height + geo.safeAreaInsets.bottom)
        }
        .task { await store.send(.view(.task)).finish() }
        .listStyle(.plain)
        .addADBackground(with: store.step.currentStep)
        .scrollContentBackground(.hidden)
        .animation(.default, value: store.step.isShowStepBar)
      }
    }
    .fullScreenOverlayPresentationSpace(.named("UploadDrawingView"))
  }
}

private extension MakeADView {
  struct PageTabView: View {
    @Perception.Bindable var store: StoreOf<MakeADFeature>
    
    var body: some View {
      WithPerceptionTracking {
        TabView(selection: $store.step.currentStep.sending(\.update.setCurrentStep)) {
          UploadDrawingView(
            store: store.scope(
              state: \.uploadDrawing,
              action: \.scope.uploadDrawing
            )
          )
          .tag(MakeADStep.UploadDrawing)
          
          FindTheCharacterView(
            store: store.scope(
              state: \.findTheCharacter,
              action: \.scope.findTheCharacter
            )
          )
          .tag(MakeADStep.FindTheCharacter)
          
          SeparateCharacterView()
            .tag(MakeADStep.SeparateCharacter)
          
          FindingCharacterJointsView()
            .tag(MakeADStep.FindCharacterJoints)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowBackground(Color.clear)
      }
    }
  }
}

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
    .fullScreenOverlayPresentationSpace(.named("UploadADrawingView"))
  }
}

struct TestReloadView: View {
  var body: some View {
    let _ = Self._printChanges()
    Rectangle()
      .frame(width: 200, height: 200)
      .foregroundStyle(randomColor)
  }
  
  var randomColor: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}

private extension MakeADView {
  struct PageTabView: View {
    @Perception.Bindable var store: StoreOf<MakeADFeature>
    
    var body: some View {
      WithPerceptionTracking {
        TabView(selection: $store.step.currentStep.sending(\.update.setCurrentStep)) {
          UploadADrawingView(
            store: store.scope(
              state: \.uploadADrawing,
              action: \.scope.uploadADrawing
            )
          )
          .tag(MakeADStep.UploadADrawing)
          
          FindingTheCharacterView(
            store: store.scope(
              state: \.findingTheCharacter,
              action: \.scope.findingTheCharacter
            )
          )
          .tag(MakeADStep.FindingTheCharacter)
          
          SeparatingCharacterView()
            .tag(MakeADStep.SeparatingCharacter)
          
          FindingCharacterJointsView()
            .tag(MakeADStep.FindingCharacterJoints)
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

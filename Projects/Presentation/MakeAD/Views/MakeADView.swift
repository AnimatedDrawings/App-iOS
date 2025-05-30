//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import FindCharacterJoints
import FindTheCharacter
import MakeADFeatures
import SeparateCharacter
import SwiftUI
import UploadDrawing

public struct MakeADView: View {
  @Bindable var store: StoreOf<MakeADFeature>

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
    .fullScreenOverlayPresentationSpace(.named("UploadDrawingView"))
  }
}

extension MakeADView {
  fileprivate struct PageTabView: View {
    @Bindable var store: StoreOf<MakeADFeature>

    var body: some View {
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

        SeparateCharacterView(
          store: store.scope(
            state: \.separateCharacter,
            action: \.scope.separateCharacter
          )
        )
        .tag(MakeADStep.SeparateCharacter)

        FindingCharacterJointsView(
          store: store.scope(
            state: \.findCharacterJoints,
            action: \.scope.findCharacterJoints
          )
        )
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

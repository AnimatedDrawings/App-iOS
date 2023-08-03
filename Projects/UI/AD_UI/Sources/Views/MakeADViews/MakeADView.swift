//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct MakeADView: ADUI {
  typealias MyFeature = MakeADFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: StoreOf<MyFeature> = rootViewStore.scope(
      state: \.makeADState,
      action: RootViewFeature.Action.makeADAction
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geo in
        List {
          if viewStore.sharedState.isShowStepStatusBar {
            StepStatusBar(
              currentStep: viewStore.state.sharedState.currentStep,
              completeStep: viewStore.state.sharedState.completeStep
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .padding()
          }
          
          PageTabView(with: viewStore)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .frame(height: geo.size.height + geo.safeAreaInsets.bottom)
        }
        .listStyle(.plain)
        .adBackground()
        .scrollContentBackground(.hidden)
      }
      .fullScreenOverlayPresentationSpace(.named("UploadADrawingView"))
    }
  }
}

extension MakeADView {
  @ViewBuilder
  func PageTabView(with viewStore: MyViewStore) -> some View {
    TabView(
      selection: viewStore.binding(
        get: \.sharedState.currentStep,
        send: MyFeature.Action.bindingCurrentStep
      )
    ) {
      UploadADrawingView()
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
  }
}

struct MakeADView_Previews: PreviewProvider {
  static var previews: some View {
    MakeADView()
  }
}
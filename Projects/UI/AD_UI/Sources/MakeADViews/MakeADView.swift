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
  typealias MyStore = MakeADStore
  let store: StoreOf<MyStore>
  
  init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(),
      reducer: MyStore()
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
        send: MyStore.Action.bindingCurrentStep
      )
    ) {
      UploadADrawingView(
        store: self.store.scope(
          state: \.uploadADrawing,
          action: MakeADStore.Action.uploadADrawing
        )
      )
      .tag(Step.UploadADrawing)
      
      FindingTheCharacterView(
        store: self.store.scope(
          state: \.findingTheCharacter,
          action: MakeADStore.Action.findingTheCharacter
        )
      )
      .tag(Step.FindingTheCharacter)
      
      SeparatingCharacterView(
        store: self.store.scope(
          state: \.separatingCharacter,
          action: MakeADStore.Action.separatingCharacter
        )
      )
      .tag(Step.SeparatingCharacter)
      
      FindingCharacterJointsView(
        store: self.store.scope(
          state: \.findingCharacterJoints,
          action: MakeADStore.Action.findingCharacterJoints
        )
      )
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

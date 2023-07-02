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
  typealias MyViewStore = ViewStore<MyStore.State, MyStore.Action>
  let store: StoreOf<MyStore>
  
  @StateObject var stepStatusBarEnvironment = StepStatusBarEnvironment()
  
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
          if !self.stepStatusBarEnvironment.isHide {
            StepStatusBar(curStep: viewStore.binding(\.sharedState.$curStep))
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
            .environmentObject(stepStatusBarEnvironment)
        }
        .listStyle(.plain)
        .adBackground()
        .scrollContentBackground(.hidden)
      }
    }
  }
}

extension MakeADView {
  @ViewBuilder
  func PageTabView(with viewStore: MyViewStore) -> some View {
    TabView(selection: viewStore.binding(\.sharedState.$curStep)) {
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
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .ignoresSafeArea()
  }
}

struct MakeADView_Previews: PreviewProvider {
  static var previews: some View {
    MakeADView()
      .environmentObject(StepStatusBarEnvironment())
  }
}

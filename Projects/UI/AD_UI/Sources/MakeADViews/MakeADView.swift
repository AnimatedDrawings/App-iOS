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
  
  @EnvironmentObject var stepStatusBarEnvironment: StepStatusBarEnvironment
  
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
      VStack {
        if !self.stepStatusBarEnvironment.isHide {
          StepStatusBar(curIdx: viewStore.curStep.rawValue)
            .padding()
        }
        
        PageTabView(with: viewStore)
      }
      .adBackground()
    }
  }
}

extension MakeADView {
  @ViewBuilder
  func PageTabView(with viewStore: MyViewStore) -> some View {
    TabView(selection: viewStore.binding(\.$curStep)) {
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

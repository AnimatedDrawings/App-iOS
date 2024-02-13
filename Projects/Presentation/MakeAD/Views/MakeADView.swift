//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitSources
import SharedProvider
import DomainModel
import UploadADrawing
import FindingTheCharacter
import SeparatingCharacter
import FindingCharacterJoints
import ThirdPartyLib
import MakeADFeatures

public struct MakeADView: ADUI {
  public typealias MyFeature = MakeADFeature
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  
  @SharedValue(\.shared.stepBar.isShowStepStatusBar) var isShowStepStatusBar
  
  public init(
    store: MyStore = Store(initialState: .init()) {
      MyFeature()
    }
  ) {
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  public var body: some View {
    GeometryReader { geo in
      List {
        // if -> ishidden 사용
        if isShowStepStatusBar {
          StepBarView(store: store.scope(state: \.stepBar, action: MakeADFeature.Action.stepBar))
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .padding()
        }
        
        PageTabView()
          .listRowSeparator(.hidden)
          .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
          .listRowBackground(Color.clear)
          .frame(height: geo.size.height + geo.safeAreaInsets.bottom)
      }
      .listStyle(.plain)
//      .addADBackground(withStepBar: true)
//      .addADBackgroundWithTrigger(<#T##curveTrigger: Binding<Bool>##Binding<Bool>#>)
//      .addADBackground()
//      .addADBackgroundWithTrigger(viewStore.$stepBar.currentStep.)
      .scrollContentBackground(.hidden)
      .animation(.default, value: isShowStepStatusBar)
    }
    .fullScreenOverlayPresentationSpace(.named("UploadADrawingView"))
  }
}

private extension MakeADView {
  struct PageTabView: View {
    @SharedValue(\.shared.stepBar.currentStep) var currentStep
    
    var body: some View {
      TabView(selection: $currentStep) {
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
}

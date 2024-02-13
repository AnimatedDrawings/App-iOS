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

public struct MakeADView: ADUI {
  public typealias MyFeature = MakeADFeature
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  
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
        if viewStore.stepBar.isShowStepBar {
          StepBar()
        }
        
        PageTab()
          .frame(height: geo.size.height + geo.safeAreaInsets.bottom)
      }
      .listStyle(.plain)
      .addADBackground(with: viewStore.$stepBar.currentStep)
      .scrollContentBackground(.hidden)
      .animation(.default, value: viewStore.stepBar.isShowStepBar)
    }
    .fullScreenOverlayPresentationSpace(.named("UploadADrawingView"))
  }
}

private extension MakeADView {
  @ViewBuilder
  func StepBar() -> some View {
    StepBarView(
      currentStep: viewStore.stepBar.currentStep,
      completeStep: viewStore.stepBar.completeStep
    )
      .listRowSeparator(.hidden)
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
      .listRowBackground(Color.clear)
      .padding()
  }
  
  @ViewBuilder
  func PageTab() -> some View {
    TabView(selection: viewStore.$stepBar.currentStep) {
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
    .listRowSeparator(.hidden)
    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    .listRowBackground(Color.clear)
  }
}

#Preview {
  MakeADView()
}

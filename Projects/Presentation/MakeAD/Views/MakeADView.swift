//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_UIKit
import SharedProvider
import Domain_Model

import UploadADrawing
import FindingTheCharacter
import SeparatingCharacter
import FindingCharacterJoints

public struct MakeADView: View {
  public init() {}
  
  @SharedValue(\.shared.stepBar.isShowStepStatusBar) var isShowStepStatusBar
  
  public var body: some View {
    GeometryReader { geo in
      List {
        if isShowStepStatusBar {
          StepBar()
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
      .addBackground()
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

// MARK: - Previews

struct MakeADView_Previews: PreviewProvider {
  static var previews: some View {
    MakeADView()
  }
}

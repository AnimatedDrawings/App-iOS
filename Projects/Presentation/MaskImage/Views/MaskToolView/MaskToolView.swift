//
//  MaskToolView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import ADResources
import ADComposableArchitecture
import MaskImageFeatures

struct MaskToolView: View {
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
  
  @State private var toolSizerSize: CGFloat = 0
  @State private var toolSizerPadding: CGFloat = 0
  private let strokeColor: Color = ADResourcesAsset.Color.blue1.swiftUIColor
  
  var body: some View {
    ZStack {
      MaskToolPanel(
        store: store,
        toolSizerSize: $toolSizerSize,
        toolSizerPadding: $toolSizerPadding,
        strokeColor: strokeColor
      )
      
      WithPerceptionTracking {
        ToolSizerButton(
          toolCircleSize: $store.toolCircleSize,
          buttonSize: toolSizerSize,
          strokeColor: strokeColor
        )
        .offset(y: -((toolSizerSize / 2) + toolSizerPadding))
      }
    }
  }
}

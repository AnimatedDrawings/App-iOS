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
  @State private var toolSizerSize: CGFloat = 0
  @State private var toolSizerPadding: CGFloat = 0
  
  private let strokeColor: Color = ADResourcesAsset.Color.blue1.swiftUIColor
  
  @State var curCircleRadius: CGFloat = 10
  
  var body: some View {
    ZStack {
      MaskToolPanel(
        toolSizerSize: $toolSizerSize,
        toolSizerPadding: $toolSizerPadding,
        strokeColor: strokeColor
      )
      
      ToolSizerButton(
        curCircleRadius: $curCircleRadius,
        buttonSize: toolSizerSize,
        strokeColor: strokeColor
      )
      .offset(y: -((toolSizerSize / 2) + toolSizerPadding))
    }
  }
}

#Preview {
  MaskToolView()
}

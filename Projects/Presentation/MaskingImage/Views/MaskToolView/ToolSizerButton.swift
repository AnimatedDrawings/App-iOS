//
//  ToolSizer.swift
//  MaskingImage
//
//  Created by minii on 2023/07/07.
//

import SwiftUI
import ADUIKitResources

struct ToolSizerButton: View {
  let strokeColor: Color = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
  let buttonSize: CGFloat
  let toolSizes: [CGFloat]
  
  @Binding var curCircleRadius: CGFloat
  @State var selectedCircle: Int = 0
  
  var curToolSize: CGFloat {
    return toolSizes[selectedCircle]
  }
  
  init(
    buttonSize: CGFloat,
    curCircleRadius: Binding<CGFloat>
  ) {
    self.buttonSize = buttonSize
    // masktoolcircleradius
    let minSize: CGFloat = 15
    let maxSize: CGFloat = buttonSize - 10
    let dist: CGFloat = (maxSize - minSize) / 3
    let tmpToolSizes = (0...3).map { index -> CGFloat in
      return minSize + (CGFloat(index) * dist)
    }
    self._curCircleRadius = curCircleRadius
    self.toolSizes = tmpToolSizes
  }
  
  var body: some View {
    Button(action: action) {
      Circle()
        .foregroundColor(strokeColor)
        .frame(width: buttonSize, height: buttonSize)
        .overlay {
          Circle()
            .strokeBorder(Color.white, lineWidth: 2)
            .frame(width: curToolSize, height: curToolSize)
            .animation(.default, value: selectedCircle)
        }
    }
  }
  
  func action() {
    let tmpIndex: Int = self.selectedCircle + 1
    let nexIndex: Int = tmpIndex >= 4 ? 0 : tmpIndex
    self.curCircleRadius = toolSizes[nexIndex]
    withAnimation {
      self.selectedCircle = nexIndex
    }
  }
}

//MARK: - Preview

struct Preview_ToolSizerButton: View {
  @State var curCircleRadius: CGFloat = 20
  
  var body: some View {
    ToolSizerButton(buttonSize: 80, curCircleRadius: $curCircleRadius)
  }
}

#Preview {
  Preview_ToolSizerButton()
}


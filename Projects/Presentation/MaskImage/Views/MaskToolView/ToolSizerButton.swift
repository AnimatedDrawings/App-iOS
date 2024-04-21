//
//  ToolSizer.swift
//  MaskingImage
//
//  Created by minii on 2023/07/07.
//

import SwiftUI

struct ToolSizerButton: View {
  @Binding var toolCircleSize: CGFloat
  @State var selectedCircle: Int = 0
  let strokeColor: Color
  let buttonSize: CGFloat
  
  init(
    toolCircleSize: Binding<CGFloat>,
    buttonSize: CGFloat,
    strokeColor: Color
  ) {
    self._toolCircleSize = toolCircleSize
    self.buttonSize = buttonSize
    self.strokeColor = strokeColor
  }
  
  var toolSizes: [CGFloat] {
    let minSize: CGFloat = 15
    let maxSize: CGFloat = buttonSize - 10
    let dist: CGFloat = (maxSize - minSize) / 3
    return (0...3).map { minSize + (CGFloat($0) * dist) }
  }
  
  var curToolSize: CGFloat {
    return toolSizes[selectedCircle]
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
    .onAppear {
      toolCircleSize = toolSizes[0]
    }
  }
  
  func action() {
    let tmpIndex: Int = self.selectedCircle + 1
    let nexIndex: Int = tmpIndex >= 4 ? 0 : tmpIndex
    self.toolCircleSize = toolSizes[nexIndex]
    withAnimation {
      self.selectedCircle = nexIndex
    }
  }
}

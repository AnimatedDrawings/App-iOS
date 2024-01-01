//
//  MaskToolView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import ADUIKitResources

struct MaskToolView: View {
  let strokeColor: Color = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
  @ObservedObject var maskToolState: MaskToolState
  let heightPanel: CGFloat = 65
  
  @State var toolSizerSize: CGFloat = 0
  @State var toolSizerPadding: CGFloat = 0
  
  @Binding var toolSizerButtonOffset: CGFloat
  
  var body: some View {
    ZStack {
      
      MaskToolPanel(toolSizerSize: $toolSizerSize, height: heightPanel)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                self.toolSizerSize = geo.size.width / 5
                self.toolSizerPadding = geo.frame(in: .global).origin.x
                self.toolSizerButtonOffset = toolSizerSize - ((geo.size.height / 2) + toolSizerPadding)
              }
          }
        )
        .overlay {
          HStack(alignment: .bottom) {
            MarkerButton()
            EraserButton()
            Spacer()
              .frame(width: toolSizerSize * 1.2)
            ResetButton()
            UndoButton()
          }
          .padding(.horizontal)
        }
        .padding()
      
      ToolSizerButton(
        strokeColor: strokeColor,
        buttonSize: toolSizerSize,
        curCircleRadius: $maskToolState.circleRadius
      )
      .offset(y: -((toolSizerSize / 2) + toolSizerPadding))
    }
  }
}




extension MaskToolView {
  @ViewBuilder
  func MaskToolButton(
    imageName: String,
    action: @escaping () -> ()
  ) -> some View {
    Button(action: action) {
      Image(systemName: imageName)
        .foregroundColor(strokeColor)
        .font(.title)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  @ViewBuilder
  func MarkerButton() -> some View {
    MaskToolButton(
      imageName: self.maskToolState.drawingAction == .draw ?
      "pencil.circle.fill" :
        "pencil.circle"
    ) {
      self.maskToolState.drawingAction = .draw
    }
  }
  
  @ViewBuilder
  func EraserButton() -> some View {
    MaskToolButton(
      imageName: self.maskToolState.drawingAction == .erase ?
      "eraser.fill" :
        "eraser"
    ) {
      self.maskToolState.drawingAction = .erase
    }
  }
  
  @ViewBuilder
  func UndoButton() -> some View {
    MaskToolButton(imageName: "arrow.uturn.backward") {
      self.maskToolState.resetAction = .undo
    }
  }
  
  @ViewBuilder
  func ResetButton() -> some View {
    MaskToolButton(imageName: "trash") {
      self.maskToolState.resetAction = .reset
    }
  }
}

struct MaskToolView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_MaskingImageView()
  }
}

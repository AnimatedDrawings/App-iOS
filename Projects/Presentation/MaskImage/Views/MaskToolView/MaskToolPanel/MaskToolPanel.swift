//
//  MaskToolPanel.swift
//  MaskImage
//
//  Created by chminii on 3/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import MaskImageFeatures
import ADComposableArchitecture

struct MaskToolPanel: View {
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
  @Binding var toolSizerSize: CGFloat
  @Binding var toolSizerPadding: CGFloat
  
  let strokeColor: Color
  private let heightPanel: CGFloat = 65
  
  var body: some View {
    MaskToolPanelBackground(toolSizerSize: $toolSizerSize, height: heightPanel)
      .background(
        GeometryReader { geo in
          Color.clear
            .onAppear {
              self.toolSizerSize = geo.size.width / 5
              self.toolSizerPadding = geo.frame(in: .global).origin.x
            }
        }
      )
      .overlay {
        HStack(alignment: .bottom) {
          WithPerceptionTracking {
            MarkerButton(
              drawingTool: $store.triggerState.drawingTool,
              strokeColor: strokeColor,
              action: store.action(.view(.maskToolAction(.setDrawingTool(.draw))))
            )
          }
          WithPerceptionTracking {
            EraserButton(
              drawingTool: $store.triggerState.drawingTool,
              strokeColor: strokeColor,
              action: store.action(.view(.maskToolAction(.setDrawingTool(.erase))))
            )
          }
          Spacer()
            .frame(width: toolSizerSize * 1.2)
          ResetButton(
            strokeColor: strokeColor,
            action: store.action(.view(.maskToolAction(.setMaskTool(.reset))))
          )
          UndoButton(
            strokeColor: strokeColor,
            action: store.action(.view(.maskToolAction(.setMaskTool(.undo))))
          )
        }
        .padding(.horizontal)
      }
      .padding()
    
  }
}

extension MaskToolPanel {
  struct MarkerButton: View {
    @Binding var drawingTool: DrawingTool
    let strokeColor: Color
    let action: () -> ()
    
    var imageName: String {
      drawingTool == .draw ?
      "pencil.circle.fill" :
      "pencil.circle"
    }
    
    var body: some View {
      Button(action: action) {
        Image(systemName: imageName)
          .foregroundColor(strokeColor)
          .font(.title)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  struct EraserButton: View {
    @Binding var drawingTool: DrawingTool
    let strokeColor: Color
    let action: () -> ()
    
    var imageName: String {
      drawingTool == .erase ?
      "eraser.fill" :
      "eraser"
    }
    
    var body: some View {
      Button(action: action) {
        Image(systemName: imageName)
          .foregroundColor(strokeColor)
          .font(.title)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  struct UndoButton: View {
    let strokeColor: Color
    let action: () -> ()
    
    let imageName = "arrow.uturn.backward"
    
    var body: some View {
      Button(action: action) {
        Image(systemName: imageName)
          .foregroundColor(strokeColor)
          .font(.title)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  struct ResetButton: View {
    let strokeColor: Color
    let action: () -> ()
    
    let imageName = "trash"
    
    var body: some View {
      Button(action: action) {
        Image(systemName: imageName)
          .foregroundColor(strokeColor)
          .font(.title)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

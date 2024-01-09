//
//  MaskToolView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import ADUIKitResources
import ThirdPartyLib
import MaskingImageFeatures

struct MaskToolView: ADUI {
  typealias MyFeature = MaskToolFeature
  let store: MyStore
  let viewStore: MyViewStore
  
  let strokeColor: Color = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
  @ObservedObject var maskToolState: MaskToolState
  let heightPanel: CGFloat = 65
  
  @State var toolSizerSize: CGFloat = 0
  @State var toolSizerPadding: CGFloat = 0
  
  @Binding var toolSizerButtonOffset: CGFloat
  
  init(
    store: MyStore = Store(initialState: .init()) {
      MyFeature()
    },
    maskToolState: MaskToolState,
    toolSizerButtonOffset: Binding<CGFloat>
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    self.maskToolState = maskToolState
    self._toolSizerButtonOffset = toolSizerButtonOffset
  }
  
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
//      self.maskToolState.drawingAction = .draw
      viewStore.send(.draw)
    }
  }
  
  @ViewBuilder
  func EraserButton() -> some View {
    MaskToolButton(
      imageName: self.maskToolState.drawingAction == .erase ?
      "eraser.fill" :
        "eraser"
    ) {
//      self.maskToolState.drawingAction = .erase
      viewStore.send(.erase)
    }
  }
  
  @ViewBuilder
  func UndoButton() -> some View {
    MaskToolButton(imageName: "arrow.uturn.backward") {
//      self.maskToolState.resetAction = .undo
      viewStore.send(.undo)
    }
  }
  
  @ViewBuilder
  func ResetButton() -> some View {
    MaskToolButton(imageName: "trash") {
//      self.maskToolState.resetAction = .reset
      viewStore.send(.reset)
    }
  }
}

//MARK: - Preview

struct Preview_MaskToolView: View {
  @StateObject var maskToolState: MaskToolState = .init()
  @State var toolSizerButtonOffset: CGFloat = 20
  
  var body: some View {
    MaskToolView(
      maskToolState: maskToolState,
      toolSizerButtonOffset: $toolSizerButtonOffset
    )
  }
}

#Preview {
  Preview_MaskToolView()
}

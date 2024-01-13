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

struct MaskToolView: View {
  @State private var toolSizerSize: CGFloat = 0
  @State private var toolSizerPadding: CGFloat = 0
  @State private var toolSizerButtonOffset: CGFloat = 0
  private let heightPanel: CGFloat = 65
  private let strokeColor: Color = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
  
  @ObservedObject var viewStore: ViewStoreOf<MaskingImageFeature>
  
  init(
    viewStore: ViewStoreOf<MaskingImageFeature>
  ) {
    self.viewStore = viewStore
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
        curCircleRadius: self.viewStore.$circleRadius
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
      imageName: self.viewStore.drawingState == .draw ?
      "pencil.circle.fill" :
        "pencil.circle"
    ) {
      viewStore.send(.selectTool(.drawingTool(.draw)))
    }
  }
  
  @ViewBuilder
  func EraserButton() -> some View {
    MaskToolButton(
      imageName: self.viewStore.drawingState == .erase ?
      "eraser.fill" :
        "eraser"
    ) {
      viewStore.send(.selectTool(.drawingTool(.erase)))
    }
  }
  
  @ViewBuilder
  func UndoButton() -> some View {
    MaskToolButton(imageName: "arrow.uturn.backward") {
      viewStore.send(.selectTool(.undo))
    }
  }
  
  @ViewBuilder
  func ResetButton() -> some View {
    MaskToolButton(imageName: "trash") {
      viewStore.send(.selectTool(.reset))
    }
  }
}


//MARK: - Preview

struct Preview_MaskToolView: View {
  @State var toolSizerButtonOffset: CGFloat = 0
  
  @StateObject var viewStore: ViewStoreOf<MaskingImageFeature>
  
  init() {
    let store: StoreOf<MaskingImageFeature> = Store(
      initialState: .init()
    ) {
      MaskingImageFeature()
    }
    self._viewStore = StateObject(wrappedValue: ViewStore(store, observe: { $0 }))
  }
  
  var body: some View {
    MaskToolView(viewStore: viewStore)
  }
}

#Preview {
  Preview_MaskToolView()
}

//
//  MaskableUIViewRepresentable.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import ADComposableArchitecture
import Combine
import MaskImageFeatures
import MaskImageInterfaces
import SwiftUI

struct MaskableUIViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MaskableUIView

  @Bindable var store: StoreOf<MaskImageFeature>
  @Binding var imageFrame: CGRect

  func makeUIView(context: Context) -> MaskableUIView {
    let maskableUIView = MaskableUIView(
      myFrame: imageFrame,
      croppedImage: store.croppedImage,
      initMaskImage: store.maskedImage
    )

    context.coordinator.maskableUIView = maskableUIView
    context.coordinator.store = store
    return maskableUIView
  }

  func updateUIView(_ uiView: MaskableUIView, context: Context) {
    uiView.updateBounds(myFrame: imageFrame)
  }
}

extension MaskableUIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }

  class Coordinator {
    var maskableUIView: MaskableUIView?
    private var cancellable = Set<AnyCancellable>()

    deinit {
      cancellable.removeAll()
    }

    var store: StoreOf<MaskImageFeature>? {
      didSet {
        store?.publisher.triggerState.drawingTool
          .sink { [weak self] curDrawingTool in
            self?.maskableUIView?.curDrawingTool = curDrawingTool
          }
          .store(in: &cancellable)

        store?.publisher.toolCircleSize
          .sink { [weak self] curToolCircleSize in
            self?.maskableUIView?.curToolCircleSize = curToolCircleSize
          }
          .store(in: &cancellable)

        store?.publisher.triggerState.maskCache.undo
          .sink { [weak self] curUndo in
            self?.maskableUIView?.undo()
          }
          .store(in: &cancellable)

        store?.publisher.triggerState.maskCache.reset
          .sink { [weak self] curReset in
            self?.maskableUIView?.reset()
          }
          .store(in: &cancellable)

        store?.publisher.triggerState.save
          .sink { [weak self] curSave in
            guard let maskedImage = self?.maskableUIView?.maskedImage else {
              return
            }

            let maskImageResult: MaskImageResult = .init(image: maskedImage)
            self?.store?.send(.delegate(.maskImageResult(maskImageResult)))
          }
          .store(in: &cancellable)
      }
    }
  }
}

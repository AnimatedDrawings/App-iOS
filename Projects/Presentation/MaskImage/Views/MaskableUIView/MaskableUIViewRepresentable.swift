//
//  MaskableUIViewRepresentable.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import Combine
import MaskImageFeatures
import ADComposableArchitecture
import MaskImageInterfaces

struct MaskableUIViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MaskableUIView
  
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
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
    
    var store: StoreOf<MaskImageFeature>? {
      didSet {
        store?.publisher.triggerState.drawingTool
          .sink { curDrawingTool in
            self.maskableUIView?.curDrawingTool = curDrawingTool
          }
          .store(in: &cancellable)
        
        store?.publisher.toolCircleSize
          .sink { curToolCircleSize in
            self.maskableUIView?.curToolCircleSize = curToolCircleSize
          }
          .store(in: &cancellable)
        
        store?.publisher.triggerState.maskTool
          .sink { curMaskTool in
            switch curMaskTool {
            case .undo:
              self.maskableUIView?.undo()
            case .reset:
              self.maskableUIView?.reset()
            }
          }
          .store(in: &cancellable)
        
        store?.publisher.triggerState.save
          .sink { _ in
            guard let maskedImage = self.maskableUIView?.maskedImage else {
              return
            }
            
            let maskImageResult: MaskImageResult = .init(image: maskedImage)
            self.store?.send(.delegate(.maskImageResult(maskImageResult)))
          }
          .store(in: &cancellable)
      }
    }
  }
}

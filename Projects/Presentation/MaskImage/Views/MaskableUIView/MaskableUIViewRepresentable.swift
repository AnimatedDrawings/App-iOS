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

struct MaskableUIViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MaskableUIView
  
  @Binding var imageFrame: CGRect
  let croppedImage: UIImage
  let initMaskImage: UIImage
  
  init(
    imageFrame: Binding<CGRect>,
    croppedImage: UIImage,
    initMaskImage: UIImage
  ) {
    self._imageFrame = imageFrame
    self.croppedImage = croppedImage
    self.initMaskImage = initMaskImage
  }
  
  func makeUIView(context: Context) -> MaskableUIView {
    let maskableUIView = MaskableUIView(
      myFrame: imageFrame,
      croppedImage: croppedImage,
      initMaskImage: initMaskImage,
      curDrawingState: .draw,
      curCircleRadius: 10
    )
    
    context.coordinator.maskableUIView = maskableUIView
//    context.coordinator.viewStore = viewStore
    
    return maskableUIView
  }
  
  func updateUIView(_ uiView: MaskableUIView, context: Context) {
//    uiView.updateBounds(myFrame: imageFrame)
  }
}

extension MaskableUIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }
  
  class Coordinator {
    var maskableView: MaskableView?
    var maskableUIView: MaskableUIView?
    private var cancellable = Set<AnyCancellable>()
    
    
    
//    var viewStore: ViewStoreOf<MaskingImageFeature>? {
//      didSet {
//        viewStore?.publisher.drawingState
//          .sink { curDrawingState in
//            self.maskableUIView?.curDrawingState = curDrawingState
//          }
//          .store(in: &cancellable)
//        
//        viewStore?.publisher.circleRadius
//          .sink { curCircleRadius in
//            self.maskableUIView?.curCircleRadius = curCircleRadius
//          }
//          .store(in: &cancellable)
//        
//        viewStore?.publisher.undoTrigger
//          .sink { _ in
//            self.maskableUIView?.undo()
//          }
//          .store(in: &cancellable)
//        
//        viewStore?.publisher.resetTrigger
//          .sink { _ in
//            self.maskableUIView?.reset()
//          }
//          .store(in: &cancellable)
//        
//        viewStore?.publisher.saveTrigger
//          .sink { _ in
//            let maskedImage = self.maskableUIView?.maskedImage
//            self.viewStore?.send(.saveMaskedImage(maskedImage))
//          }
//          .store(in: &cancellable)
//      }
//    }
  }
}
//
//  MaskableUIViewRepresentable.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import Combine
import MaskingImageFeatures
import ThirdPartyLib

//struct MaskableUIViewRepresentable: UIViewRepresentable {
//  typealias UIViewType = MaskableUIView
//  let myFrame: CGRect
//  let croppedImage: UIImage
//  let initMaskImage: UIImage
//  let maskToolState: MaskToolState
//  let maskableViewLink: MaskableViewLink
//  
//  func makeUIView(context: Context) -> MaskableUIView {
//    let maskableUIView = MaskableUIView(
//      myFrame: myFrame,
//      croppedImage: self.croppedImage,
//      initMaskImage: self.initMaskImage,
//      curDrawingAction: self.maskToolState.drawingAction,
//      curCircleRadius: self.maskToolState.circleRadius
//    )
//    
//    context.coordinator.maskableUIView = maskableUIView
//    context.coordinator.maskToolState = self.maskToolState
//    context.coordinator.maskableViewLink = self.maskableViewLink
//    
//    return maskableUIView
//  }
//  
//  func updateUIView(_ uiView: MaskableUIView, context: Context) {
//    uiView.updateBounds(myFrame: myFrame)
//  }
//}

//extension MaskableUIViewRepresentable {
//  func makeCoordinator() -> Coordinator {
//    return Coordinator()
//  }
//  
//  class Coordinator {
//    var maskableUIView: MaskableUIView?
//    private var cancellable = Set<AnyCancellable>()
//    
//    var maskableViewLink: MaskableViewLink? {
//      didSet {
//        self.maskableViewLink?.startMasking
//          .sink {
//            guard let maskableViewLink = self.maskableViewLink else {
//              return
//            }
//            guard let maskedImage = self.maskableUIView?.maskedImage else {
//              maskableViewLink.finishMasking.send(false)
//              return
//            }
//            maskableViewLink.maskedImage = maskedImage
//            maskableViewLink.finishMasking.send(true)
//          }
//          .store(in: &self.cancellable)
//      }
//    }
//    
//    var maskToolState: MaskToolState? {
//      didSet {
//        self.maskToolState?.$drawingAction
//          .sink { action in
//            self.maskableUIView?.curDrawingAction = action
//          }
//          .store(in: &self.cancellable)
//        
//        self.maskToolState?.$circleRadius
//          .sink { radius in
//            self.maskableUIView?.curCircleRadius = radius
//          }
//          .store(in: &self.cancellable)
//        
//        self.maskToolState?.$resetAction
//          .sink { action in
//            switch action {
//            case .undo:
//              self.maskableUIView?.undo()
//            case .reset:
//              self.maskableUIView?.reset()
//            }
//          }
//          .store(in: &self.cancellable)
//      }
//    }
//  }
//}

struct MaskableUIViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MaskableUIView
  let myFrame: CGRect
  let croppedImage: UIImage
  let initMaskImage: UIImage
  let viewStore: ViewStoreOf<MaskingImageFeature>
  
  init(
    myFrame: CGRect,
    croppedImage: UIImage,
    initMaskImage: UIImage,
    viewStore: ViewStoreOf<MaskingImageFeature>
  ) {
    self.myFrame = myFrame
    self.croppedImage = croppedImage
    self.initMaskImage = initMaskImage
    self.viewStore = viewStore
  }
  
  func makeUIView(context: Context) -> MaskableUIView {
    let maskableUIView = MaskableUIView(
      myFrame: myFrame,
      croppedImage: croppedImage,
      initMaskImage: initMaskImage,
      curDrawingState: viewStore.drawingState,
      curCircleRadius: viewStore.circleRadius
    )
    
    context.coordinator.maskableUIView = maskableUIView
    context.coordinator.viewStore = viewStore
    
    return maskableUIView
  }
  
  func updateUIView(_ uiView: MaskableUIView, context: Context) {
    uiView.updateBounds(myFrame: myFrame)
  }
}

extension MaskableUIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }
  
  class Coordinator {
    var maskableUIView: MaskableUIView?
    private var cancellable = Set<AnyCancellable>()
    
    var viewStore: ViewStoreOf<MaskingImageFeature>? {
      didSet {
        viewStore?.publisher.drawingState
          .sink { curDrawingState in
            self.maskableUIView?.curDrawingState = curDrawingState
          }
          .store(in: &cancellable)
        
        viewStore?.publisher.circleRadius
          .sink { curCircleRadius in
            self.maskableUIView?.curCircleRadius = curCircleRadius
          }
          .store(in: &cancellable)
        
        viewStore?.publisher.undoTrigger
          .sink { _ in
            self.maskableUIView?.undo()
          }
          .store(in: &cancellable)
        
        viewStore?.publisher.resetTrigger
          .sink { _ in
            self.maskableUIView?.reset()
          }
          .store(in: &cancellable)
      }
    }
  }
}

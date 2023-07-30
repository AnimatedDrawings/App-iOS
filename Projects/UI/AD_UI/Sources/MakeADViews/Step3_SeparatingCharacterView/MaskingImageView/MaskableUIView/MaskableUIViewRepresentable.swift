//
//  MaskableUIViewRepresentable.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import Combine

struct MaskableUIViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MaskableUIView
  let myFrame: CGRect
  let croppedImage: UIImage
  let initMaskImage: UIImage
  let maskToolState: MaskToolState
  let maskableViewLink: MaskableViewLink
  
  func makeUIView(context: Context) -> MaskableUIView {
    let maskableUIView = MaskableUIView(
      myFrame: myFrame,
      croppedImage: self.croppedImage,
      initMaskImage: self.initMaskImage,
      curDrawingAction: self.maskToolState.drawingAction,
      curCircleRadius: self.maskToolState.circleRadius
    )
    
    context.coordinator.maskableUIView = maskableUIView
    context.coordinator.maskToolState = self.maskToolState
    context.coordinator.maskableViewLink = self.maskableViewLink
    
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
    
    var maskableViewLink: MaskableViewLink? {
      didSet {
        self.maskableViewLink?.startMasking
          .sink {
            guard let maskableViewLink = self.maskableViewLink else {
              return
            }
            guard let maskedImage = self.maskableUIView?.maskedImage else {
              maskableViewLink.finishMasking.send(false)
              return
            }
            maskableViewLink.maskedImage = maskedImage
            maskableViewLink.finishMasking.send(true)
          }
          .store(in: &self.cancellable)
      }
    }
    
    var maskToolState: MaskToolState? {
      didSet {
        self.maskToolState?.$drawingAction
          .sink { action in
            self.maskableUIView?.curDrawingAction = action
          }
          .store(in: &self.cancellable)
        
        self.maskToolState?.$circleRadius
          .sink { radius in
            self.maskableUIView?.curCircleRadius = radius
          }
          .store(in: &self.cancellable)
        
        self.maskToolState?.$resetAction
          .sink { action in
            switch action {
            case .undo:
              self.maskableUIView?.undo()
            case .reset:
              self.maskableUIView?.reset()
            }
          }
          .store(in: &self.cancellable)
      }
    }
  }
}

struct MaskableUIViewRepresentable_Previews: PreviewProvider {
  static var previews: some View {
    Previews_MaskingImageView()
  }
}

//
//  MaskableViewLink.swift
//  MaskingImage
//
//  Created by minii on 2023/07/10.
//

import SwiftUI
import Combine

class MaskableViewLink: ObservableObject {
  @Binding var maskedImage: UIImage?
  
  var startMasking = PassthroughSubject<Void, Never>()
  var finishMasking = PassthroughSubject<Bool, Never>()
  var anyCancellable = Set<AnyCancellable>()
  
  private let maskNextAction: (Bool) -> ()
  private let cancelAction: () -> ()
  
  init(
    maskedImage: Binding<UIImage?>,
    maskNextAction: @escaping (Bool) -> (),
    cancelAction: @escaping () -> ()
  ) {
    self._maskedImage = maskedImage
    self.maskNextAction = maskNextAction
    self.cancelAction = cancelAction
    
    saveNextAction()
  }
}

extension MaskableViewLink {
  func save() {
    self.startMasking.send()
  }
  
  func saveNextAction() {
    self.finishMasking
      .sink { maskResult in
        self.maskNextAction(maskResult)
      }
      .store(in: &self.anyCancellable)
  }
}

extension MaskableViewLink {
  func cancel() {
    self.cancelAction()
  }
}

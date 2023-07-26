//
//  FullScreenOverlayContainer.swift
//  AD_Utils
//
//  Created by minii on 2023/07/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

class FullScreenOverlayContainer: ObservableObject {
  static let shared: FullScreenOverlayContainer = .init()
  
  @Published private(set) var overlays: [PresentationSpace: [AnyHashable: AnyView]] = .init()
  
  func updateOverlay<ID: Hashable, Overlay: View>(_ overlay: Overlay, for id: ID, in presentationSpace: PresentationSpace) {
    self.overlays[presentationSpace, default: [:]].updateValue(AnyView(overlay), forKey: id)
  }
  
  func removeOverlay<ID: Hashable>(for id: ID, in presentationSpace: PresentationSpace) {
    self.overlays[presentationSpace, default: [:]].removeValue(forKey: id)
  }
}

//
//  GIFPresentationController.swift
//  AD_Utils
//
//  Created by minii on 2023/09/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import SwiftUI
import ImageIO

private let kDefaultGIFFrameInterval: TimeInterval = 1.0 / 24.0

struct GIFPresentationController {
  let gifData: Data
  
  init(gifData: Data) {
    self.gifData = gifData
  }
  
  func start(changeFrame: (CGImage) async -> Void) async {
    do {
      repeat {
        for try await cgImage in try CGImageSourceFrameSequence(data: gifData) {
          try await update(cgImage: cgImage, changeFrame: changeFrame)
        }
      } while(true)
    } catch {
      
    }
  }
  
  private func update(cgImage: CGImage, changeFrame: (CGImage) async -> Void) async throws {
    await changeFrame(cgImage)
    try await Task.sleep(nanoseconds: UInt64(kDefaultGIFFrameInterval * 1_000_000_000.0))
  }
}

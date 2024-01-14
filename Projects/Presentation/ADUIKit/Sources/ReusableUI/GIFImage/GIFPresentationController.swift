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
  
  func start(errorImage: CGImage, changeFrame: (CGImage) async -> Void) async {
    do {
      repeat {
        for try await imageFrame in try CGImageSourceFrameSequence(data: gifData) {
          try await update(imageFrame: imageFrame, changeFrame: changeFrame)
        }
      } while(true)
    } catch {
      await changeFrame(errorImage)
    }
  }
  
  private func update(imageFrame: ImageFrame, changeFrame: (CGImage) async -> Void) async throws {
    await changeFrame(imageFrame.image)
    let interval: Double = imageFrame.interval ?? kDefaultGIFFrameInterval
    try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000.0))
  }
}

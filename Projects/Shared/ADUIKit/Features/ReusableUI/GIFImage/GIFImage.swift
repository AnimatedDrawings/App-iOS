//
//  GIFImage.swift
//  AD_Utils
//
//  Created by minii on 2023/08/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADResources

public struct GIFImage: View {
  private let gifData: Data
  private let gifPresentationController: GIFPresentationController
  @State var currentFrame: CGImage?
  var convertUIImage: UIImage {
    if let currentFrame = self.currentFrame {
      return UIImage(cgImage: currentFrame)
    }
    return UIImage()
  }

  private let errorImage: CGImage = ADResourcesAsset.SampleDrawing.checkerboard.image.cgImage!
  
  public init(gifData: Data) {
    self.gifData = gifData
    self.gifPresentationController = GIFPresentationController(gifData: gifData)
  }
  
  public init(sample: ADResourcesData) {
    self.gifData = sample.data.data
    self.gifPresentationController = GIFPresentationController(gifData: gifData)
  }
  
  public var body: some View {
    Image(uiImage: convertUIImage)
      .resizable()
      .scaledToFit()
      .task(id: gifData) {
        await load()
      }
  }
}

extension GIFImage {
  @MainActor
  private func changeFrame(_ currentFrame: CGImage) {
    self.currentFrame = currentFrame
  }
  
  private func load() async {
    await gifPresentationController.start(errorImage: errorImage, changeFrame: changeFrame(_:))
  }
}

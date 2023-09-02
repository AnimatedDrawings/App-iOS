//
//  GIFImage.swift
//  AD_Utils
//
//  Created by minii on 2023/08/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct GIFImage: View {
  private let gifData: Data
  private let gifPresentationController: GIFPresentationController
  @MainActor @State var currentFrame: CGImage?
  @MainActor var convertUIImage: UIImage {
    if let currentFrame = self.currentFrame {
      return UIImage(cgImage: currentFrame)
    }
    return UIImage()
  }
  @State private var presentationTask: Task<(), Never>?
  
  private let errorImage: CGImage = ADUtilsAsset.SampleDrawing.checkerboard.image.cgImage!
  
  public init(gifData: Data) {
    self.gifData = gifData
    self.gifPresentationController = GIFPresentationController(gifData: gifData)
  }
  
  public init(sample: ADUtilsData) {
    self.gifData = sample.data.data
    self.gifPresentationController = GIFPresentationController(gifData: gifData)
  }
  
  public var body: some View {
    Image(uiImage: convertUIImage)
      .resizable()
      .scaledToFit()
      .task(id: gifData, load)
  }
}

extension GIFImage {
  @MainActor
  @Sendable private func changeFrame(_ currentFrame: CGImage) async {
    self.currentFrame = currentFrame
  }
  
  @Sendable private func load() {
    presentationTask?.cancel()
    presentationTask = Task {
      await gifPresentationController.start(errorImage: errorImage, changeFrame: changeFrame(_:))
    }
  }
}

// MARK: - Previews_GIFImage
struct Previews_GIFImage: View {
  let sampleGIFData: Data = ADUtilsAsset.Gifs.step2Gif1.data.data
  
  var body: some View {
    GIFImage(gifData: sampleGIFData)
  }
}

struct GIFImage_Previews: PreviewProvider {
  static var previews: some View {
    Previews_GIFImage()
  }
}

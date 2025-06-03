import ImageIO
import MobileCoreServices
import UIKit

class GIFCreator {
  func createGIF(from images: [UIImage], duration: TimeInterval) -> Data? {
    guard !images.isEmpty else { return nil }

    let frameCount = images.count
    let frameDelay = duration / Double(frameCount)

    let fileProperties =
      [
        kCGImagePropertyGIFDictionary: [
          kCGImagePropertyGIFHasGlobalColorMap: true,
          kCGImagePropertyColorModel: kCGImagePropertyColorModelRGB,
          kCGImagePropertyDepth: 8,
          kCGImagePropertyGIFLoopCount: 0,
        ]
      ] as CFDictionary

    let frameProperties =
      [
        kCGImagePropertyGIFDictionary: [
          kCGImagePropertyGIFDelayTime: frameDelay
        ]
      ] as CFDictionary

    guard let data = CFDataCreateMutable(nil, 0),
      let destination = CGImageDestinationCreateWithData(
        data,
        kUTTypeGIF,
        frameCount,
        nil
      )
    else {
      return nil
    }

    CGImageDestinationSetProperties(destination, fileProperties)

    for image in images {
      if let cgImage = image.cgImage {
        CGImageDestinationAddImage(destination, cgImage, frameProperties)
      }
    }

    guard CGImageDestinationFinalize(destination) else {
      return nil
    }

    return data as Data
  }
}

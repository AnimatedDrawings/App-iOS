//
//  ImageCompressor.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import ADUIKitResources
import UIKit
import DomainModel
import ImageCompressorInterfaces

/// Use
struct ImageCompressor: ImageCompressorProtocol {
  func compress(with data: Data) throws -> CompressedInfo {
    guard let image = UIImage(data: data),
          let result = reduceFileSize(image: image)
    else {
      throw NSError()
    }
    
    return result
  }
  
  func compress(with image: UIImage) throws -> CompressedInfo {
    guard let result = reduceFileSize(image: image)
    else {
      throw NSError()
    }
    return result
  }
}
 
extension ImageCompressor {
  func reduceFileSize(image: UIImage) -> CompressedInfo? {
    let resizedImage = resizeImage(with: image)
    guard let compressedData = compressImage(with: resizedImage),
          let compressedImage = UIImage(data: compressedData)
    else {
      return nil
    }
    
    return CompressedInfo(data: compressedData, image: compressedImage, original: image)
  }
  
  func compressImage(
    with image: UIImage,
    maxKB: Double = 2000
  ) -> Data? {
    guard let data = image.pngData() else {
      return nil
    }
    if data.getSize(.kilobyte) < maxKB {
      return data
    }

    let sizeInBytes = Int(maxKB * 1024)
    var needCompress = true
    var imageData: Data? = nil
    var compressingValue: CGFloat = 1.0
    while (needCompress && compressingValue > 0.0) {
      if let data: Data = image.jpegData(compressionQuality: compressingValue) {
        if data.count < sizeInBytes {
          needCompress = false
          imageData = data
        } else {
          compressingValue -= 0.1
        }
      } else {
        return nil
      }
    }
    
    return imageData
  }
  
  func resizeImage(
    with image: UIImage,
    resizeWidth: Double = 600
  ) -> UIImage {
    let scale = resizeWidth / image.size.width
    if 1 < scale || 0 == scale { return image }
    let resizeHeight = image.size.height * scale

    let size = CGSize(width: resizeWidth, height: resizeHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
      image.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }
}

extension DependencyValues {
  var imageCompressor: any ImageCompressorProtocol {
    get { self[ImageCompressorKey.self] }
    set { self[ImageCompressorKey.self] = newValue }
  }
}

enum ImageCompressorKey: DependencyKey {
  static let liveValue: any ImageCompressorProtocol = ImageCompressor()
  static let testValue: any ImageCompressorProtocol = TestImageCompressor()
}

struct TestImageCompressor: ImageCompressorProtocol {
  func compress(with data: Data) throws -> CompressedInfo {
    return CompressedInfo.mock()
  }
  
  func compress(with image: UIImage) throws -> CompressedInfo {
    return CompressedInfo.mock()
  }
}

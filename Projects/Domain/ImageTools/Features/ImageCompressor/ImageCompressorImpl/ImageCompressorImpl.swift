//
//  ImageCompressorImpl.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADResources
import UIKit
import ImageToolsInterfaces

/// Use
public struct ImageCompressorImpl: ImageCompressorProtocol {
  public init() {}
  
  public func compress(with data: Data) throws -> CompressResponse {
    guard let image = UIImage(data: data),
          let result = reduceFileSize(image: image)
    else {
      throw NSError()
    }
    
    return result
  }
  
  public func compress(with image: UIImage) throws -> CompressResponse {
    guard let result = reduceFileSize(image: image)
    else {
      throw NSError()
    }
    return result
  }
}
 
extension ImageCompressorImpl {
  func reduceFileSize(image: UIImage) -> CompressResponse? {
    let resizedImage = resizeImage(with: image)
    guard let compressedData = compressImage(with: resizedImage),
          let compressedImage = UIImage(data: compressedData)
    else {
      return nil
    }
    
//    return CompressResponse(data: compressedData, image: compressedImage, original: image)
    return .init(data: compressedData, image: compressedImage)
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
    if 1 <= scale { return image }
    let resizeHeight = image.size.height * scale

    let size = CGSize(width: resizeWidth, height: resizeHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
      image.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }
}

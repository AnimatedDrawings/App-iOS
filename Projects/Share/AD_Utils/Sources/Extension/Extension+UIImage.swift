//
//  Extension+UIImage.swift
//  AD_Utils
//
//  Created by minii on 2023/07/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import UIKit

public extension UIImage {
  func reduceFileSize(maxKB: Double) -> Data? {
    guard let selfData = self.pngData() else {
      return nil
    }
    
    if selfData.getSize(.kilobyte) < maxKB {
      return selfData
    }

    let newWidth: CGFloat = 600
    let resizedImage: UIImage = newWidth < self.size.width ?
    self.resize(newWidth: newWidth) :
    self
    
    if let resizedData = resizedImage.pngData(),
       resizedData.getSize(.kilobyte) < maxKB
    {
      return resizedData
    }
    
    if let compressedData = self.compressTo(maxKB: Int(maxKB)) {
      return compressedData
    }
    return selfData
  }
  
  func compressTo(maxKB: Int) -> Data? {
    let sizeInBytes = maxKB * 1024
    var needCompress = true
    var imgData: Data? = nil
    var compressingValue: CGFloat = 1.0
    while (needCompress && compressingValue > 0.0) {
      if let data: Data = self.jpegData(compressionQuality: compressingValue) {
        if data.count < sizeInBytes {
          needCompress = false
          imgData = data
        } else {
          compressingValue -= 0.1
        }
      }
    }
    
    return imgData
  }
  
  func resize(newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    if 0 < scale { return self }
    let newHeight = self.size.height * scale

    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
      self.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }
}

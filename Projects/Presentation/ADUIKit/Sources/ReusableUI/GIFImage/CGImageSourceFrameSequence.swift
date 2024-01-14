//
//  CGImageSourceFrameSequence.swift
//  AD_Utils
//
//  Created by minii on 2023/09/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import ImageIO

struct CGImageSourceFrameSequence: AsyncSequence {
  typealias Element = ImageFrame
  
  let source: CGImageSource
  
  enum LoadError: Error {
    case invalidData
    case emptyData
  }
  
  init(source: CGImageSource) {
    self.source = source
  }
  
  init(data: Data) throws {
    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
      throw LoadError.invalidData
    }
    
    switch CGImageSourceGetStatus(source) {
    case .statusComplete: break
    case .statusReadingHeader: break
    case .statusIncomplete: throw LoadError.emptyData
    case .statusInvalidData: throw LoadError.invalidData
    case .statusUnexpectedEOF: throw LoadError.invalidData
    case .statusUnknownType: throw LoadError.invalidData
    @unknown default: throw LoadError.invalidData
    }
    
    self.init(source: source)
  }
  
  func makeAsyncIterator() -> CGImageSourceIterator {
    CGImageSourceIterator(source: source)
  }
}

struct CGImageSourceIterator: AsyncIteratorProtocol {
  let frameCount: Int
  let source: CGImageSource
  private(set) var currentFrame: Int
  
  init(source: CGImageSource) {
    self.source = source
    self.frameCount = CGImageSourceGetCount(source)
    self.currentFrame = 0
  }
  
  mutating func next() async throws -> ImageFrame? {
    guard currentFrame < frameCount else {
      return nil
    }
    
    let imageFrame: ImageFrame?
    if let nextImage = CGImageSourceCreateImageAtIndex(source, currentFrame, nil) {
      imageFrame = ImageFrame(image: nextImage, interval: source.intervalAtIndex(currentFrame))
    } else {
      imageFrame = nil
    }
    currentFrame += 1
    return imageFrame
  }
}

extension CFString {
  var asKey: UnsafeMutableRawPointer {
    return Unmanaged.passUnretained(self).toOpaque()
  }
}

extension CGImageSource {
  func intervalAtIndex(_ index: Int) -> TimeInterval? {
    guard let properties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) else {
      return nil
    }
    
    guard let gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary.asKey) else {
      return nil
    }
    
    let dictionary = unsafeBitCast(gifProperties, to: CFDictionary.self)
    
    let pointer: UnsafeRawPointer
    if let delay = CFDictionaryGetValue(dictionary, kCGImagePropertyGIFDelayTime.asKey) {
      pointer = delay
    } else if let unclampedDelay = CFDictionaryGetValue(dictionary, kCGImagePropertyGIFUnclampedDelayTime.asKey) {
      pointer = unclampedDelay
    } else {
      return nil
    }
    
    let interval = unsafeBitCast(pointer, to: AnyObject.self).doubleValue ?? 0.0
    if interval > 0.0 {
      return interval
    } else {
      return nil
    }
  }
}


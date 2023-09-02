//
//  CGImageSourceFrameSequence.swift
//  AD_Utils
//
//  Created by minii on 2023/09/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import ImageIO

struct CGImageSourceIterator: AsyncIteratorProtocol {
  let frameCount: Int
  let source: CGImageSource
  private(set) var currentFrame: Int
  
  init(source: CGImageSource) {
    self.source = source
    self.frameCount = CGImageSourceGetCount(source)
    self.currentFrame = 0
  }
  
  mutating func next() async throws -> CGImage? {
    guard currentFrame < frameCount else {
      return nil
    }
    
    let cgImage: CGImage? = CGImageSourceCreateImageAtIndex(source, currentFrame, nil)
    currentFrame += 1
    return cgImage
  }
}

struct CGImageSourceFrameSequence: AsyncSequence {
  typealias Element = CGImage
  
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

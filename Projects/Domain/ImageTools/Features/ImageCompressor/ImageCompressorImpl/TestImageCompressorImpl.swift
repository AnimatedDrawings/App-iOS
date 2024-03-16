//
//  TestImageCompressorImpl.swift
//  ImageTools
//
//  Created by chminii on 3/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ImageToolsInterfaces
import UIKit

public struct TestImageCompressorImpl: ImageCompressorProtocol {
  public init() {}
  
  public func compress(with data: Data) throws -> CompressResponse {
    return .mock()
  }
  
  public func compress(with image: UIImage) throws -> CompressResponse {
    return .mock()
  }
}

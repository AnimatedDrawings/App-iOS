//
//  TestImageCompressorImpl.swift
//  ImageTools
//
//  Created by chminii on 3/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ImageToolsInterfaces
import DomainModel
import UIKit

public struct TestImageCompressorImpl: ImageCompressorProtocol {
  public init() {}
  
  public func compress(with data: Data) throws -> CompressedInfo {
    return CompressedInfo.mock()
  }
  
  public func compress(with image: UIImage) throws -> CompressedInfo {
    return CompressedInfo.mock()
  }
}

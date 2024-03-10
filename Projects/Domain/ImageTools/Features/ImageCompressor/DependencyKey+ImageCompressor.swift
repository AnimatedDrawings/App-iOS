//
//  DependencyKey+ImageCompressor.swift
//  ImageTools
//
//  Created by chminii on 3/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import ImageToolsInterfaces

public enum ImageCompressor: DependencyKey {
  public static let liveValue: any ImageCompressorProtocol = ImageCompressorImpl()
  public static let testValue: any ImageCompressorProtocol = TestImageCompressorImpl()
}

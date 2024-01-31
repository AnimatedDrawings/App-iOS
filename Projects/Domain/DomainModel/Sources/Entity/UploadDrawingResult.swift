//
//  UploadDrawingResult.swift
//  DomainModel
//
//  Created by minii on 2023/10/16.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct UploadDrawingResult: Equatable {
  public let ad_id: String
  public let boundingBox: CGRect
  
  public init(
    ad_id: String,
    boundingBox: CGRect
  ) {
    self.ad_id = ad_id
    self.boundingBox = boundingBox
  }
}

public extension UploadDrawingResult {
  static func example1Mock() -> Self {
    UploadDrawingResult(
      ad_id: "ad_id",
      boundingBox: CGRect(
        x: 88.0,
        y: 118.0,
        width: 176.0,
        height: 284.0
      )
    )
  }
}

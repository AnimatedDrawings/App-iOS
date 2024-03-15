//
//  UploadADrawingResult.swift
//  DomainModel
//
//  Created by minii on 2023/10/16.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct UploadADrawingResult: Equatable {
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

public extension UploadADrawingResult {
  static func example1Mock() -> Self {
    UploadADrawingResult(
      ad_id: "example1",
      boundingBox: CGRect(
        x: 88.0,
        y: 118.0,
        width: 176.0,
        height: 284.0
      )
    )
  }
}

//
//  UploadDrawingResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct UploadDrawingResponse: Equatable {
  public let ad_id: String
  public let boundingBox: BoundingBox
  
  public init(
    ad_id: String,
    boundingBox: BoundingBox
  ) {
    self.ad_id = ad_id
    self.boundingBox = boundingBox
  }
}

public extension UploadDrawingResponse {
  static func mock() -> Self {
    return Self(
      ad_id: String(describing: Self.self),
      boundingBox: BoundingBox.mockExample2()
    )
  }
}

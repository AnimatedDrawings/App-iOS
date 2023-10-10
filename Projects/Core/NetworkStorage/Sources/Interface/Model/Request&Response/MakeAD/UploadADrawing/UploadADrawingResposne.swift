//
//  UploadADrawingResposne.swift
//  AD_Feature
//
//  Created by minii on 2023/07/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct UploadADrawingResponse: Responsable {
  public let ad_id: String
  public let boundingBoxDTO: BoundingBoxDTO
  
  public init(ad_id: String, boundingBoxDTO: BoundingBoxDTO) {
    self.ad_id = ad_id
    self.boundingBoxDTO = boundingBoxDTO
  }
  
  enum CodingKeys: String, CodingKey {
    case ad_id
    case boundingBoxDTO = "bounding_box"
  }
}

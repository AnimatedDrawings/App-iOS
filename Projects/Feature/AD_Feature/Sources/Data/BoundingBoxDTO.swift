//
//  BoundingBoxDTO.swift
//  AD_Feature
//
//  Created by minii on 2023/07/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct UploadADrawingResposne: Decodable, Equatable {
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

public struct BoundingBoxDTO: Decodable, Equatable {
  public let top: Int
  public let bottom: Int
  public let left: Int
  public let right: Int
  
  public init(top: Int, bottom: Int, left: Int, right: Int) {
    self.top = top
    self.bottom = bottom
    self.left = left
    self.right = right
  }
  
  enum CodingKeys: String, CodingKey {
    case top
    case bottom
    case left
    case right
  }
}

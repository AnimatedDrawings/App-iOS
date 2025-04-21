//
//  DownloadAnimationRequest.swift
//  NetworkStorage
//
//  Created by chminii on 4/8/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import Foundation

public struct DownloadAnimationRequest: Encodable {
  public let ad_id: String
  public let adAnimation: String

  public init(ad_id: String, adAnimation: String) {
    self.ad_id = ad_id
    self.adAnimation = adAnimation
  }

  enum CodingKeys: String, CodingKey {
    case ad_id
    case adAnimation = "ad_animation"
  }
}


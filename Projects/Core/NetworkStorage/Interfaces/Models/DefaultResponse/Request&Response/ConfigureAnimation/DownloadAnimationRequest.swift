//
//  DownloadAnimationRequest.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct DownloadAnimationRequest {
  public let ad_id: String
  public let animationInfo: ADAnimationRequestInfo
  
  public init(ad_id: String, animationInfo: ADAnimationRequestInfo) {
    self.ad_id = ad_id
    self.animationInfo = animationInfo
  }
}

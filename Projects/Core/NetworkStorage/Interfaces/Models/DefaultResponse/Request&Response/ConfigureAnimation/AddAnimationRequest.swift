//
//  AddAnimationRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct AddAnimationRequest {
  public let ad_id: String
  public let animationInfo: ADAnimationRequestInfo
  
  public init(ad_id: String, animationInfo: ADAnimationRequestInfo) {
    self.ad_id = ad_id
    self.animationInfo = animationInfo
  }
}

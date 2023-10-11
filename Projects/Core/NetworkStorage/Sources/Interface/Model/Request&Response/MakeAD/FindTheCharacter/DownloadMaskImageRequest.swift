//
//  DownloadMaskImageRequest.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct DownloadMaskImageRequest {
  public let ad_id: String
  
  public init(ad_id: String) {
    self.ad_id = ad_id
  }
}

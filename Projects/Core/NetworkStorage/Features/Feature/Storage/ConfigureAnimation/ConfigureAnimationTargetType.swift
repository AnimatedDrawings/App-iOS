//
//  ConfigureAnimationTargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces

enum ConfigureAnimationTargetType {
  case add(AddAnimationRequest)
  case download(DownloadAnimationRequest)
}

fileprivate let configureAnimationPath: String = "/api/configure_animation/"

extension ConfigureAnimationTargetType: TargetType {
  var path: String {
    switch self {
    case .add(let request):
      return configureAnimationPath + "add/\(request.ad_id)"
    case .download(let request):
      return configureAnimationPath + "download_video/\(request.ad_id)"
    }
  }
  
  var method: HttpMethod {
    switch self {
    case .add:
      return .post
    case .download:
      return .post
    }
  }
  
  var queryParameters: [String : String]? {
    return nil
  }

  var task: NetworkTask {
    switch self {
    case .add(let request):
      return .requestJSONEncodable(request.adAnimationDTO)
    case .download(let request):
      return .requestJSONEncodable(request.adAnimationDTO)
    }
  }
}

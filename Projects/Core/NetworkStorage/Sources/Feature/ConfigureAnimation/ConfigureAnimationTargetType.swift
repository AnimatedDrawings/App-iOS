//
//  ConfigureAnimationTargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

enum ConfigureAnimationTargetType {
  case add(ConfigureAnimationRequest)
  case downloadVideo(ConfigureAnimationRequest)
}

fileprivate let configureAnimationPath: String = "/api/configure_animation/"

extension ConfigureAnimationTargetType: TargetType {
  var path: String {
    switch self {
    case .add(let request):
      return configureAnimationPath + "add/\(request.ad_id)"
    case .downloadVideo(let request):
      return configureAnimationPath + "download_video/\(request.ad_id)"
    }
  }
  
  var method: HttpMethod {
    switch self {
    case .add:
      return .post
    case .downloadVideo:
      return .post
    }
  }
  
  var queryParameters: [String : String]? {
    return nil
  }
  
  var headers: [String : String]? {
    switch self {
    case .add:
      return ["Content-type" : "application/json"]
    case .downloadVideo:
      return ["Content-type" : "application/json"]
    }
  }
  
  var task: NetworkTask {
    switch self {
    case .add(let request):
      return .requestJSONEncodable(request.adAnimationDTO)
    case .downloadVideo(let request):
      return .requestJSONEncodable(request.adAnimationDTO)
    }
  }
}

//
//  ConfigureAnimationTargetType.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import Moya

let providerConfigureAnimation = MoyaProvider<ConfigureAnimationTargetType>()

enum ConfigureAnimationTargetType {
  case add(ConfigureAnimationRequest)
  case downloadVideo(ConfigureAnimationRequest)
}

fileprivate let configureAnimationPath: String = "/api/configure_animation/"

extension ConfigureAnimationTargetType: TargetType {
  var baseURL: URL { URL(string: "https://miniiad.duckdns.org")! }
  
  var path: String {
    switch self {
    case .add(let request):
      return configureAnimationPath + "add/\(request.ad_id)"
    case .downloadVideo(let request):
      return configureAnimationPath + "download_video/\(request.ad_id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .add:
      return .post
    case .downloadVideo:
      return .post
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .add:
      return ["Content-type" : "application/json"]
    case .downloadVideo:
      return ["Content-type" : "application/json"]
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .add(let request):
      return .requestJSONEncodable(request.adAnimationDTO)
    case .downloadVideo(let request):
      return .requestJSONEncodable(request.adAnimationDTO)
    }
  }
}

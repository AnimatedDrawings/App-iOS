//
//  AddAnimationTargetType.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import Moya

let providerAddAnimation = MoyaProvider<AddAnimationTargetType>()

enum AddAnimationTargetType {
  case addAnimation(AddAnimationRequest)
}

fileprivate let addAnimationPath: String = "/api/add_animation/"

extension AddAnimationTargetType: TargetType {
  var baseURL: URL { URL(string: "https://miniiad.duckdns.org")! }
  
  var path: String {
    switch self {
    case .addAnimation(let request):
      return addAnimationPath + request.ad_id
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .addAnimation:
      return .post
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .addAnimation:
      return ["Content-type" : "application/json"]
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .addAnimation(let request):
      return .requestJSONEncodable(request)
    }
  }
}

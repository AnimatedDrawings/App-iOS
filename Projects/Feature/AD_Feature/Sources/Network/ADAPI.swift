//
//  ADAPI.swift
//  AD_Feature
//
//  Created by minii on 2023/06/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import Moya

let providerAD = MoyaProvider<ADTargetType>()

enum ADTargetType {
  case uploadImage(croppedImage: UIImage)
}

fileprivate let makeADPath: String = "/api/makeAD/"

extension ADTargetType: TargetType {
  var baseURL: URL { URL(string: "https://miniiad.duckdns.org")! }
  
  var path: String {
    switch self {
    case .uploadImage:
      return makeADPath + "upload_image"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .uploadImage:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .uploadImage(let croppedImage):
      let imageData = MultipartFormData(
        provider: .data(croppedImage.pngData() ?? Data()),
        name: "croppedImage",
        fileName: "croppedImage.png",
        mimeType: "iamge/png"
      )
      
      return .uploadMultipart([imageData])
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

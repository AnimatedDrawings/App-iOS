//
//  UploadImageError.swift
//  AD_Feature
//
//  Created by minii on 2023/06/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

enum UploadImageError: Error {
  case convertData
  case urlRequest
  case multipartFormData
}

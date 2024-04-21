//
//  NetworkTask.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public enum NetworkTask {
  case requestPlain
  case requestJSONEncodable(Encodable)
  case uploadMultipart(Data)
}

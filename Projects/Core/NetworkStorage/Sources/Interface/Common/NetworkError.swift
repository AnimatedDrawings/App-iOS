//
//  NetworkError.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
  case makeUrlComponent
  case makeURL
  case requestJSONEncodable
  case convertResponseModel
  case emptyResponse
  case ADServerError
}

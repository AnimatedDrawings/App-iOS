//
//  Extension+Moya.swift
//  AD_Utils
//
//  Created by minii on 2023/06/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Moya

public extension MoyaProvider {
  func request(_ target: Target) async -> Result<Response, MoyaError> {
    await withCheckedContinuation { continuation in
      self.request(target) { result in
        continuation.resume(returning: result)
      }
    }
  }
}

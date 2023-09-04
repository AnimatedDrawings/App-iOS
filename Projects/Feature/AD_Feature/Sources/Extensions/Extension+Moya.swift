//
//  Extension+Moya.swift
//  AD_Feature
//
//  Created by minii on 2023/09/04.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Moya

extension MoyaProvider {
  func request(_ target: Target) async -> Result<Response, MoyaError> {
    await withCheckedContinuation { continuation in
      self.request(target) { result in
        continuation.resume(returning: result)
      }
    }
  }
}

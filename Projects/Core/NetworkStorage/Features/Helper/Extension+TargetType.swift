// //
// //  Extension+TargetType.swift
// //  NetworkStorage
// //
// //  Created by chminii on 3/11/24.
// //  Copyright 2024 chminipark. All rights reserved.
// //

import NetworkStorageInterfaces

extension TargetType {
  var baseURL: String {
    return Env.baseUrl
  }
}

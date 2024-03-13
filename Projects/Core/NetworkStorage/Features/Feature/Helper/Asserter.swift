//
//  Asserter.swift
//  NetworkStorageInterfaces
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

struct Asserter<T> {
  func generic(_ val: Any) -> Bool {
    let type = type(of: val)
    return T.self == type
  }
}

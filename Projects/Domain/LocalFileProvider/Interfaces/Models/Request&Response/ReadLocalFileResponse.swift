//
//  ReadLocalFileResponse.swift
//  LocalFileProviderInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct ReadLocalFileResponse {
  public let data: Data
  
  public init(data: Data) {
    self.data = data
  }
}

//
//  ReadLocalFileResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct ReadLocalFileResponse {
  public let data: Data
  
  public init(data: Data) {
    self.data = data
  }
}

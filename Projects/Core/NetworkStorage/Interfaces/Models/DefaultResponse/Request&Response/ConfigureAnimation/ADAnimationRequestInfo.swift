//
//  ADAnimationRequestInfo.swift
//  NetworkStorageInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct ADAnimationRequestInfo: Codable {
  public let name: String
  
  public init(name: String) {
    self.name = name
  }
}

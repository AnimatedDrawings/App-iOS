//
//  SaveLocalFileResponse.swift
//  DomainModels
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public struct SaveLocalFileResponse {
  public let fileURL: URL
  
  public init(fileURL: URL) {
    self.fileURL = fileURL
  }
}

public enum FileExtension: String {
  case gif
}

//
//  DataUnits.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public enum DataUnits: String {
  case byte, kilobyte, megabyte, gigabyte
}

public extension Data {
  func getSize(_ type: DataUnits = .megabyte) -> Double {
    let bytes = self.count
    let size: Double
    
    switch type {
    case .byte:
      size = Double(bytes)
    case .kilobyte:
      size = Double(bytes) / 1024
    case .megabyte:
      size = Double(bytes) / 1024 / 1024
    case .gigabyte:
      size = Double(bytes) / 1024 / 1024 / 1024
    }
    
    return size
  }
}

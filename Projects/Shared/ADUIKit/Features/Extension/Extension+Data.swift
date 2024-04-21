//
//  Extension+Data.swift
//  AD_Utils
//
//  Created by minii on 2023/06/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public extension Data {
  var mimeType: String {
    var b: UInt8 = 0
    self.copyBytes(to: &b, count: 1)
    
    switch b {
    case 0xFF:
      return "image/jpeg"
    case 0x89:
      return "image/png"
    case 0x47:
      return "image/gif"
    case 0x4D, 0x49:
      return "image/tiff"
    case 0x25:
      return "application/pdf"
    case 0xD0:
      return "application/vnd"
    case 0x46:
      return "text/plain"
    default:
      return "application/octet-stream"
    }
  }
}

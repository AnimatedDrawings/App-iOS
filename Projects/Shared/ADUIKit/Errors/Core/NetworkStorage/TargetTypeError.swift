//
//  TargetTypeError.swift
//  ADErrors
//
//  Created by chminii on 3/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public enum TargetTypeError: Error {
  case makeUrlComponent
  case makeURL
  case requestJSONEncodable
}

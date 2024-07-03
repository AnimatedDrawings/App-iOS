//
//  String.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription

public extension String {
  static let chminipark = "chminipark"
  
  var replaceBar: String {
    self.replacingOccurrences(of: "_", with: "-")
  }
}

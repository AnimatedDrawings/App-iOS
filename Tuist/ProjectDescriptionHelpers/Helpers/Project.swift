//
//  Project.swift
//  ProjectEnvironment
//
//  Created by chminii on 7/3/24.
//

import ProjectDescription

public extension Project.Options {
  static var enableCodeCoverage: Self {
    return .options(
      automaticSchemesOptions: .enabled(
        codeCoverageEnabled: true
      )
    )
  }
}

public extension ProjectDescription.ResourceFileElements {
  static var resource: Self {
    ["Resources/**"]
  }
}

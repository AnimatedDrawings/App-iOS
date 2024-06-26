//
//  ProjectConfiguration.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/2/24.
//

import ProjectDescription

public extension Configuration {
  static func build(_ type: BuildTarget) -> Self {
    switch type {
    case .dev:
      return .debug(
        name: type.configurationName,
        xcconfig: type.xcConfigPath
      )
    case .prd:
      return .release(
        name: type.configurationName,
        xcconfig: type.xcConfigPath
      )
    }
  }
}

public enum BuildTarget: String {
  case dev = "DEV"
  case prd = "PRD"
  
  public var configurationName: ConfigurationName {
    return .configuration(self.rawValue)
  }
  
  public var xcConfigPath: Path {
    return .relativeToRoot("XCConfig/\(rawValue.lowercased()).xcconfig")
  }
}

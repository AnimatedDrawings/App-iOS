//
//  ProjectConfiguration.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/2/24.
//

import ProjectDescription

public extension Configuration {
  static var dev: Self {
    return .debug(name: BuildTarget.dev.configurationName)
  }
  
  static var prd: Self {
    return .debug(name: BuildTarget.prd.configurationName)
  }
}

public enum BuildTarget: String {
  case dev = "DEV"
  case prd = "PRD"
  
  public var configurationName: ConfigurationName {
    return .configuration(self.rawValue)
  }
}

public extension Path {
  static func relativeToXCConfig(_ type: BuildTarget) -> Self {
    return .relativeToRoot("./XCConfig/\(type.rawValue.lowercased()).xcconfig")
  }
}

//
//  Scheme.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.

import ProjectDescription

public extension Scheme {
  static func makeScheme(name: String, targets: [TargetReference], type: BuildTarget) -> Self {
    let name = "\(name)_\(type.rawValue)"
    
    switch type {
    case .dev:
      return .scheme(
        name: name,
        buildAction: .buildAction(targets: targets),
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
      
    case .prd:
      return .scheme(
        name: name,
        buildAction: .buildAction(targets: targets),
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
    }
  }
}

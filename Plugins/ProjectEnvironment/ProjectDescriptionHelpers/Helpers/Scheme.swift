//
//  Scheme.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.

import ProjectDescription

public extension Scheme {
  static func makeScheme(
    type: BuildTarget,
    projectName: String,
    targets: [Target]
  ) -> Self {
    let name = "\(projectName)_\(type.rawValue)"
    let buildAction: BuildAction = .buildAction(targets: targets.map { .target($0.name)} )
    
    switch type {
    case .dev:
      return .scheme(
        name: name,
        buildAction: buildAction,
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
      
    case .prd:
      return .scheme(
        name: name,
        buildAction: buildAction,
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
    }
  }
}

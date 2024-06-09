//
//  Scheme.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription

public extension Scheme {
  static func makeScheme(_ type: BuildTarget) -> Self {
    switch type {
    case .dev:
      return .scheme(
        name: type.rawValue,
        buildAction: .buildAction(targets: .init(arrayLiteral: .init(stringLiteral: type.rawValue))),
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
      
    case .prd:
      return .scheme(
        name: type.rawValue,
        buildAction: .buildAction(targets: .init(arrayLiteral: .init(stringLiteral: type.rawValue))),
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
    }
  }
}

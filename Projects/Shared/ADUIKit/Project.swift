//
//  Project.swift
//  Config
//
//  Created by chminii on 2/26/24.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = ADUIKit.makeProject(
  targets: [
    ADUIKit.example(
      sources: [.example, .features],
      dependencies: [.features]
    ),
    ADUIKit.features(
      dependencies: [
        .target(name: ADUIKit.resources),
        .target(name: ADUIKit.errors)
      ]
    ),
    ADUIKit.resourceTarget(),
    ADUIKit.errorsTarget()
  ]
)

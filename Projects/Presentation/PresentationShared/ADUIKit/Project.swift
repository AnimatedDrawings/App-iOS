//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ADUIKit.projectName,
  targets: [
    .makeTarget(
      targetName: ADUIKit.targetName,
      product: .staticFramework,
      dependencies: [
        Domain.projectDepedency
      ]
    )
  ]
)

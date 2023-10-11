//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: AD_UIKit.projectName,
  targets: [
    .makeTarget(
      targetName: AD_UIKit.targetName,
      product: .staticFramework,
      dependencies: [
        Domain.projectDepedency
      ]
    )
  ]
)

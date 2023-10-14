//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ModifyJoints.projectName,
  targets: [
    .makeTarget(
      targetName: ModifyJoints.targetName,
      product: .staticLibrary,
      dependencies: [
        ADUIKit.projectDepedency
      ]
    )
  ]
)

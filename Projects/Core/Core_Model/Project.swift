//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/11.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Core_Model.projectName,
  targets: [
    .makeTarget(
      targetName: Core_Model.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Shared.projectDepedency
      ]
    )
  ]
)


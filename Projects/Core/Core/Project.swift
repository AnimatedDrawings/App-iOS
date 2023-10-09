//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/13.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Core.projectName,
  targets: [
    .makeTarget(
      targetName: Core.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        LocalFileStorage.projectDepedency,
        SharedStorage.projectDepedency
      ]
    )
  ]
)

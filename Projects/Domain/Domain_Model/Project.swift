//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Domain_Model.projectName,
  targets: [
    .makeTarget(
      targetName: Domain_Model.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Core.projectDepedency
      ]
    )
  ]
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: SharedProvider.projectName,
  targets: [
    .makeTarget(
      targetName: SharedProvider.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Domain_Model.projectDepedency
      ]
    )
  ]
)

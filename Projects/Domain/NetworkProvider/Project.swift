//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: NetworkProvider.projectName,
  targets: [
    .makeTarget(
      targetName: NetworkProvider.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Domain_Model.projectDepedency
      ]
    )
  ]
)

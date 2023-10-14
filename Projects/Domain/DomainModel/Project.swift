//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: DomainModel.projectName,
  targets: [
    .makeTarget(
      targetName: DomainModel.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Core.projectDepedency
      ]
    )
  ]
)

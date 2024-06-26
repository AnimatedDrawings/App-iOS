//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: DomainModels.projectName,
  targets: [
    .makeTarget(
      name: DomainModels.featureName,
      product: .staticLibrary,
      dependencies: [
        Core.projectDepedency
      ]
    )
  ]
)

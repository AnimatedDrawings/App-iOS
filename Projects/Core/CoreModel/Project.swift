//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/11.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: CoreModel.projectName,
  targets: [
    .makeTarget(
      name: CoreModel.featureName,
      product: .staticLibrary,
      dependencies: [Shared.projectDepedency]
    )
  ]
)

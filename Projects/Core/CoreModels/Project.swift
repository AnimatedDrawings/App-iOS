//
//  Project.swift
//  Config
//
//  Created by chminii on 3/15/24.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: CoreModels.projectName,
  targets: [
    .makeTarget(
      name: CoreModels.featureName,
      product: .staticLibrary,
      dependencies: [
        Shared.projectDepedency
      ]
    )
  ]
)

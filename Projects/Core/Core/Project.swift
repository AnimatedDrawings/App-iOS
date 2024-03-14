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
      name: Core.featureName,
      product: .staticLibrary,
      dependencies: [
        LocalFileStorage.projectDepedency,
        NetworkStorage.projectDepedency
      ]
    )
  ]
)

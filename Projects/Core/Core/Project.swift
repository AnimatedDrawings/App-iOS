//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = Core.makeProject(
  targets: [
    .makeTarget(
      name: Core.featureName,
      product: .staticLibrary,
      dependencies: [
        NetworkStorage.projectDepedency
      ]
    )
  ]
)

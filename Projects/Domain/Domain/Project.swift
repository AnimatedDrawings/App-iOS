//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = Domain.makeProject(
  targets: [
    .makeTarget(
      name: Domain.featureName,
      product: .staticLibrary,
      dependencies: [
        SharedProvider.projectDepedency,
        NetworkProvider.projectDepedency,
      ]
    )
  ]
)

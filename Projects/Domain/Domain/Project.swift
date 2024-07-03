//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = Domain.makeProject(
  targets: [
    .makeTarget(
      name: Domain.featureName,
      product: .staticLibrary,
      dependencies: [
        LocalFileProvider.projectDepedency,
        SharedProvider.projectDepedency,
        NetworkProvider.projectDepedency,
        ImageTools.projectDepedency
      ]
    )
  ]
)

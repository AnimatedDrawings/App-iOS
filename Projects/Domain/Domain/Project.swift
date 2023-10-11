//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Domain.projectName,
  targets: [
    .makeTarget(
      targetName: Domain.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        LocalFileProvider.projectDepedency,
        SharedProvider.projectDepedency,
        NetworkProvider.projectDepedency
      ]
    )
  ]
)

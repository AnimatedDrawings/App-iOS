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
      name: DomainModel.featureName,
      product: .staticLibrary,
      dependencies: [
        Core.projectDepedency
      ]
    )
  ]
)

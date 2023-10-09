//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/14.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: LocalFileProvider.projectName,
  targets: [
    .makeTarget(
      targetName: LocalFileProvider.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Domain_Model.projectDepedency
      ]
    )
  ]
)

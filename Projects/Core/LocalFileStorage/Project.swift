//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/14.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: LocalFileStorage.projectName,
  targets: [
    .makeTarget(
      targetName: LocalFileStorage.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Core_Model.projectDepedency
      ]
    )
  ]
)

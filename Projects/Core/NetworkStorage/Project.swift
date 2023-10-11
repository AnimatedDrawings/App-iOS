//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: NetworkStorage.projectName,
  targets: [
    .makeTarget(
      targetName: NetworkStorage.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        Core_Model.projectDepedency
      ]
    )
  ]
)
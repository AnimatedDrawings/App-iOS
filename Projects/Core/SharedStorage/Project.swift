//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: SharedStorage.projectName,
  options: .enableCodeCoverage,
  targets: [
    .makeTarget(
      targetName: SharedStorage.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        CoreModel.projectDepedency
      ]
    ),
    .makeTestTarget(targetName: SharedStorage.targetName)
  ]
)

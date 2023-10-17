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
  options: .enableCodeCoverage,
  targets: [
    .makeTarget(
      targetName: LocalFileStorage.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        CoreModel.projectDepedency
      ]
    ),
    .makeTestTarget(targetName: LocalFileStorage.targetName)
  ]
)

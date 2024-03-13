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
    LocalFileStorage.tests(
      dependencies: [.features]
    ),
    LocalFileStorage.features(
      dependencies: [Shared.projectDepedency]
    )
  ]
)

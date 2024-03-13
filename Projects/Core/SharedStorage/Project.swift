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
    SharedStorage.tests(
      dependencies: [.features]
    ),
    SharedStorage.features(
      dependencies: [Shared.projectDepedency]
    )
  ]
)

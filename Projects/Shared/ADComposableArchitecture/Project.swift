//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/09.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ADComposableArchitecture.projectName,
  packages: [.ComposableArchitecture],
  targets: [
    .makeTarget(
      name: ADComposableArchitecture.projectName,
      product: .staticLibrary,
      dependencies: [.ComposableArchitecture]
    )
  ]
)

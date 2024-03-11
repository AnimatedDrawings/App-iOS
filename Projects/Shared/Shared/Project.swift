//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/08.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Shared.projectName,
  targets: [
    .makeTarget(
      name: Shared.projectName,
      product: .staticLibrary,
      dependencies: [
        .project(
          target: ADUIKit.resources,
          path: .relativeToRoot(Shared.prefixPathString + "/\(ADUIKit.projectName)")
        ),
        ADComposableArchitecture.projectDepedency,
        ADAsyncAlgorithms.projectDepedency
      ]
    )
  ]
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ADComposableArchitecture.makeProject(
  targets: [
    .makeTarget(
      name: ADComposableArchitecture.projectName,
      product: .staticLibrary,
      dependencies: [
        .external(name: "ComposableArchitecture")
      ]
    )
  ]
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/08.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = Shared.makeProject(
  targets: [
    .makeTarget(
      name: Shared.projectName,
      product: .staticLibrary,
      dependencies: [
        ADUIKit.projectDepedency,
        ADComposableArchitecture.projectDepedency,
        ADAsyncAlgorithms.projectDepedency,
        ADAlamofire.projectDepedency,
        .external(name: "GoogleMobileAds")
      ]
    )
  ]
)

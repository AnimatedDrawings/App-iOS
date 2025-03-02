//
//  Project.swift
//  Config
//
//  Created by chminii on 3/11/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ADAsyncAlgorithms.makeProject(
  targets: [
    .makeTarget(
      name: ADAsyncAlgorithms.projectName,
      product: .staticLibrary,
      dependencies: [
        .external(name: "AsyncAlgorithms")
      ]
    )
  ]
)

//
//  Project.swift
//  Config
//
//  Created by chminii on 3/11/24.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ADAsyncAlgorithms.projectName,
  packages: [.AsyncAlgorithms],
  targets: [
    .makeTarget(
      name: ADAsyncAlgorithms.projectName,
      product: .staticLibrary,
      dependencies: [.AsyncAlgorithms]
    )
  ]
)

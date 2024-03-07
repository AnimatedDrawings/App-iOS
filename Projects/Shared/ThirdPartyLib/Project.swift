//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/09.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ThirdPartyLib.projectName,
  packages: [.ComposableArchitecture, .AsyncAlgorithms],
  targets: [
    .makeTarget(
      name: ThirdPartyLib.projectName,
      product: .staticLibrary,
      dependencies: [.ComposableArchitecture, .AsyncAlgorithms]
    )
  ]
)

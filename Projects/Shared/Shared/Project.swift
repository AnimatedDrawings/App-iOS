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
      targetName: Shared.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        ThirdPartyLib.projectDepedency
      ]
    )
  ]
)

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
  targets: [
    .makeTarget(
      targetName: ThirdPartyLib.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        .Moya,
        .ComposableArchitecture
      ]
    )
  ]
)

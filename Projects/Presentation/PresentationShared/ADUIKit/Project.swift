//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ADUIKit.projectName,
  targets: [
    .makeTarget(
      targetName: ADUIKit.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        .target(name: ADUIKit.projectName + "Resources")
      ]
    ),
    .makeTarget(
      targetName: ADUIKit.projectName + "Resources",
      product: .staticLibrary,
      sources: nil,
      dependencies: [
        Domain.projectDepedency
      ]
    ),
    .makeTarget(
      targetName: ADUIKit.projectName + "Example",
      product: .app,
      infoPlist: .AD,
      sources: ["Example/**", "Sources/**"],
      resources: nil,
      dependencies: [
        .target(name: ADUIKit.targetName)
      ]
    )
  ]
)

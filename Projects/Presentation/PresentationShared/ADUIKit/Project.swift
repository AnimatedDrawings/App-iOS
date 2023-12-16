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
//      product: .staticFramework,
      product: .staticLibrary,
      dependencies: [
        Domain.projectDepedency
      ]
    ),
    .makeTarget(
      targetName: ADUIKit.targetName + "Example",
      product: .app,
      infoPlist: .AD,
      // sources: ["Example/**", "Sources/**", "Derived/Sources/**"],
      sources: ["Example/**", "Sources/**"],
      resources: nil,
      dependencies: [
        .target(name: ADUIKit.targetName)
      ]
    )
  ]
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ConfigureAnimation.projectName,
  targets: [
    ConfigureAnimation.example(),
    ConfigureAnimation.views(),
    ConfigureAnimation.features(
      dependencies: [
        PresentationShared.projectDepedency
      ]
    ),
    ConfigureAnimation.tests()
  ]
)

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
    ConfigureAnimation.view(),
    ConfigureAnimation.feature(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    )
  ]
)

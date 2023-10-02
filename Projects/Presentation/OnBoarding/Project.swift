//
//  OnBoarding.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: OnBoarding.projectName,
  targets: [
    OnBoarding.views(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    ),
    OnBoarding.example()
  ]
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ConfigureAnimation.makeProject(
  options: .enableCodeCoverage,
  targets:
    ConfigureAnimation
    .uPresentationTargets(
      dependencies: [Domain.projectDepedency]
    )
)

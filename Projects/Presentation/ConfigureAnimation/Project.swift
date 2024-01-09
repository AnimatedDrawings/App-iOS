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
  options: .enableCodeCoverage,
  targets: ConfigureAnimation
    .uPresentationTargets(
      resource: false,
      dependency: PresentationShared.projectDepedency
    )
)

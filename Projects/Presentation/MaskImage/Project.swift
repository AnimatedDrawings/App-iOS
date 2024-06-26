//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: MaskImage.projectName,
  options: .enableCodeCoverage,
  targets: MaskImage
    .uPresentationTargets(
      dependencies: [Domain.projectDepedency]
    )
)

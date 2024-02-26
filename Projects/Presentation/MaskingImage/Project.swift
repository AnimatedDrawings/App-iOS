//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: MaskingImage.projectName,
  options: .enableCodeCoverage,
  targets: MaskingImage
    .uPresentationTargets(
      dependencies: [ADUIKit.projectDepedency]
    )
)

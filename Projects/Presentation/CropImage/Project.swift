//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/18.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: CropImage.projectName,
  options: .enableCodeCoverage,
  targets: CropImage
    .uPresentationTargets(
      resource: false,
      dependency: ADUIKit.projectDepedency
    )
)

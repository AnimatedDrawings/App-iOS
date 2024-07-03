//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/18.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = CropImage.makeProject(
  options: .enableCodeCoverage,
  targets: CropImage
    .uPresentationTargets(
      dependencies: [Domain.projectDepedency]
    )
)

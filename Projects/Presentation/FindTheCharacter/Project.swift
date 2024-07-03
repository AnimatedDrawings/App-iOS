//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = FindTheCharacter.makeProject(
  options: .enableCodeCoverage,
  targets: FindTheCharacter
    .uPresentationTargets(
      dependencies: [CropImage.projectDepedency]
    )
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = SeparateCharacter.makeProject(
  options: .enableCodeCoverage,
  targets: SeparateCharacter
    .uPresentationTargets(
      dependencies: [MaskImage.projectDepedency]
    )
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: SeparateCharacter.projectName,
  options: .enableCodeCoverage,
  targets: SeparateCharacter
    .uPresentationTargets(
      dependencies: [MaskImage.projectDepedency]
    )
)

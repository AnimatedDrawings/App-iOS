//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: FindTheCharacter.projectName,
  options: .enableCodeCoverage,
  targets: FindTheCharacter
    .uPresentationTargets(
      dependencies: [CropImage.projectDepedency]
    )
)

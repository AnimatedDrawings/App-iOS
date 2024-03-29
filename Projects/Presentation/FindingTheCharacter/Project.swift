//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: FindingTheCharacter.projectName,
  options: .enableCodeCoverage,
  targets: FindingTheCharacter
    .uPresentationTargets(
      resource: false,
      dependency: CropImage.projectDepedency
    )
)

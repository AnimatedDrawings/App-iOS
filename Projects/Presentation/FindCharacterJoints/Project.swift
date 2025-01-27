//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = FindCharacterJoints.makeProject(
  options: .enableCodeCoverage,
  targets: FindCharacterJoints
    .uPresentationTargets(
      dependencies: [ModifyJoints.projectDepedency]
    )
)

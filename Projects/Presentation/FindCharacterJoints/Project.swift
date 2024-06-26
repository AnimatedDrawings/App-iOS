//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: FindCharacterJoints.projectName,
  options: .enableCodeCoverage,
  targets: FindCharacterJoints
    .uPresentationTargets(
      dependencies: [ModifyJoints.projectDepedency]
    )
)

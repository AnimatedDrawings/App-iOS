//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/19.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = ModifyJoints.makeProject(
  options: .enableCodeCoverage,
  targets: ModifyJoints
    .uPresentationTargets(
      dependencies: [Domain.projectDepedency]
    )
)

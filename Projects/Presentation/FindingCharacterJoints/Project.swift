//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: FindingCharacterJoints.projectName,
  options: .enableCodeCoverage,
  targets: FindingCharacterJoints
    .uPresentationTargets(
      resource: false,
      dependency: PresentationShared.projectDepedency
    )
)

//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: MakeAD.projectName,
  options: .enableCodeCoverage,
  targets: MakeAD
    .uPresentationTargets(
      dependencies: [
        UploadADrawing.projectDepedency,
        FindingTheCharacter.projectDepedency,
        SeparatingCharacter.projectDepedency,
        FindingCharacterJoints.projectDepedency
      ]
    )
)

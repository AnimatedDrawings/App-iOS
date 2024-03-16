//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: UploadDrawing.projectName,
  options: .enableCodeCoverage,
  targets: UploadDrawing
    .uPresentationTargets(
      dependencies: [Domain.projectDepedency]
    )
)

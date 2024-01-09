//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: UploadADrawing.projectName,
  options: .enableCodeCoverage,
  targets: UploadADrawing
    .uPresentationTargets(
      resource: false,
      dependency: PresentationShared.projectDepedency
    )
)

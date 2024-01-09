//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/18.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: PresentationShared.projectName,
  targets: [
    .makeTarget(
      targetName: PresentationShared.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
//        CropImage.projectDepedency,
        MaskingImage.projectDepedency,
        ModifyJoints.projectDepedency
      ]
    )
  ]
)

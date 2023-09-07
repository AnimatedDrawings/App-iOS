//
//  Project.swift
//  Config
//
//  Created by minii on 2023/08/23.
//

import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_CropImage
let releaseTarget: Target = .makeTarget(
  targetName: myModule.name,
  product: .staticLibrary,
  dependencies: [
    .release(.AD_Utils)
  ]
)

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    releaseTarget
  ],
  schemes: []
)

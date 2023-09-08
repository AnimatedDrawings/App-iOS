//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/08.
//

import ProjectDescription
import ProjectEnvironment

//let myModule: MyModule = .AD_Utils
//let releaseTarget: Target = .makeTarget(
//  targetName: myModule.name,
//  product: .staticLibrary
//)

//
//let project: Project = .makeProject(
//  myModule: myModule,
//  targets: [
//    releaseTarget
//  ],
//  schemes: []
//)
//

let myModule: MyModule = .AD_Shared
let releaseTarget: Target = .makeTarget(
  targetName: myModule.name,
  product: .staticLibrary,
  resources: nil,
  dependencies: [
    .release(.AD_Utils),
    .release(.ThirdPartyLib)
  ]
)

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    releaseTarget
  ]
)

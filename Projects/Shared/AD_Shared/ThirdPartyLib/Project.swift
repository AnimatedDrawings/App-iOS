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

let myModule: MyModule = .ThirdPartyLib

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        .Moya,
        .ComposableArchitecture
      ]
    )
  ]
)


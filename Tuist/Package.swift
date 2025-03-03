//
//  Package.swift
//  ProjectDescriptionHelpers
//
//  Created by chminii on 3/2/25.
//

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "AnimatedDrawingPKG",
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      exact: "1.18.0"
    ),
    .package(
      url: "https://github.com/apple/swift-async-algorithms",
      exact: "1.0.0"
    ),
  ],
  targets: [
    .target(
      name: "AnimatedDrawingPKG",
      dependencies: [
        "ComposableArchitecture",
        "AsyncAlgorithms",
      ]
    )
  ]
)

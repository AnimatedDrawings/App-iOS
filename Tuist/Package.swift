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
      url: "https://github.com/apple/swift-async-algorithms.git",
      exact: "1.0.0"
    ),
    .package(
      url: "https://github.com/Alamofire/Alamofire.git",
      exact: "5.10.2"
    ),
    .package(
      url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
      from: "12.4.0"
    ),
    .package(
      url: "https://github.com/jpsim/Yams.git",
      exact: "6.0.0"
    ),
  ],
  targets: [
    .target(
      name: "AnimatedDrawingPKG",
      dependencies: [
        "ComposableArchitecture",
        "AsyncAlgorithms",
        "Alamofire",
        "GoogleMobileAds",
        "Yams",
      ]
    )
  ]
)

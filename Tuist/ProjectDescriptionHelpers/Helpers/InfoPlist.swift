//
//  InfoPlist.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import Foundation
import ProjectDescription

func loadEnvVariables(from path: String) -> [String: String] {
  guard let envString = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8) else {
    return [:]
  }
  let envLines = envString.split(separator: "\n")
  var envDict: [String: String] = [:]
  envLines.forEach { line in
    let parts = line.split(separator: "=")
    if parts.count == 2 {
      let key = String(parts[0])
      let value = String(parts[1])
      envDict[key] = value
    }
  }
  return envDict
}

let env = loadEnvVariables(from: "./.env")
let admobAppId = env["ADMOB_APP_ID"] ?? "ca-app-pub-defaultAdId"

extension ProjectDescription.InfoPlist {
  public static var forPresentationLayer: Self {
    let plist: [String: Plist.Value] = [
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
      "ENABLE_TESTS": .boolean(true),
      "NSPhotoLibraryUsageDescription":
        "We need access to photo library so that photos can be selected",
      "NSPhotoLibraryAddUsageDescription": "This app requires access to the photo library.",
      "UIUserInterfaceStyle": "Light",
      "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
      "GADEnableNetworkTracing": .boolean(true),
      "GADApplicationIdentifier": .string(admobAppId),
      "SKAdNetworkItems": [
        ["SKAdNetworkIdentifier": .string("cstr6suwn9.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("4fzdc2evr5.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("2fnua5tdw4.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("ydx93a7ass.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("p78axxw29g.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("v72qych5uu.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("ludvb6z3bs.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("cp8zw746q7.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("3sh42y64q3.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("c6k4g5qg8m.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("s39g8k73mm.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("3qy4746246.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("f38h382jlk.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("hs6bdukanm.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("mlmmfzh3r3.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("v4nxqhlyqp.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("wzmmz9fp6w.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("su67r6k2v3.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("yclnxrl5pm.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("t38b2kh725.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("7ug5zh24hu.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("gta9lk7p23.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("vutu7akeur.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("y5ghdn5j9k.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("v9wttpbfk9.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("n38lu8286q.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("47vhws6wlr.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("kbd757ywx3.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("9t245vhmpl.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("a2p9lx4jpn.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("22mmun2rn5.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("44jx6755aq.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("k674qkevps.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("4468km3ulz.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("2u9pt9hc89.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("8s468mfl3y.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("klf5c3l5u5.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("ppxm28t8ap.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("kbmxgpxpgc.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("uw77j35x4d.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("578prtvx9j.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("4dzt52r2t5.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("tl55sbb4fm.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("c3frkrj4fj.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("e5fvkxwrpn.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("8c4e2ghe7u.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("3rd42ekr43.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("97r2b46745.skadnetwork")],
        ["SKAdNetworkIdentifier": .string("3qcr597p9d.skadnetwork")],
      ],
    ]
    return .extendingDefault(with: plist)
  }
}

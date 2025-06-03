import ADResources
import Foundation
import Yams
import UIKit

public enum DevResources: String {
  case example1 = "Example1"
  case garlic
}

public extension DevResources {
  var croppedImage: ADResourcesImages {
    switch self {
    case .example1:
      return ADResourcesAsset.Example1TestImages.e1Texture
    case .garlic:
      return ADResourcesAsset.GarlicTestImages.croppedImage
    }
  }
}

public extension DevResources {
  var boundingBox: CGRect {
    let bundle = ADResourcesResources.bundle
    let fileName: String = "bounding_box"

    guard let yamlPath = bundle.path(forResource: fileName, ofType: "yaml") else {
      return .zero
    }

    guard let yamlString = try? String(contentsOf: URL(fileURLWithPath: yamlPath), encoding: .utf8)
    else {
      return .zero
    }

    guard let yamlDict = try? Yams.load(yaml: yamlString) as? [String: Any] else {
      return .zero
    }

    // Helper function to convert Any to Double
    func getDouble(from value: Any?) -> Double? {
      if let doubleValue = value as? Double {
        return doubleValue
      } else if let intValue = value as? Int {
        return Double(intValue)
      }
      return nil
    }

    guard let left = getDouble(from: yamlDict["left"]),
      let right = getDouble(from: yamlDict["right"]),
      let top = getDouble(from: yamlDict["top"]),
      let bottom = getDouble(from: yamlDict["bottom"])
    else {
      return .zero
    }

    return CGRect(x: left, y: top, width: right - left, height: bottom - top)
  }
}

//
//  Joints.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import Foundation
import CoreModels

public struct Joints: Equatable, Decodable {
  public let imageWidth: CGFloat
  public let imageHeight: CGFloat
  public var skeletons: [String : Skeleton]
  
  public init(
    imageWidth: CGFloat,
    imageHeight: CGFloat,
    skeletons: [String : Skeleton]
  ) {
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.skeletons = skeletons
  }
  
  public init(dto: JointsDTO) {
    let imageWidth = CGFloat(dto.width)
    let imageHeight = CGFloat(dto.height)
    let skeletons = dto.skeletonDTO
      .reduce(into: [String : Skeleton](), { dict, dto in
        let name: String = dto.name
        let ratioX: CGFloat = imageWidth == 0 ? 0 : CGFloat(dto.location[0]) / imageWidth
        let ratioY: CGFloat = imageHeight == 0 ? 0 : CGFloat(dto.location[1]) / imageHeight
        let ratioPoint = RatioPoint(x: ratioX, y: ratioY)
        
        dict[name] = Skeleton(
          name: name,
          ratioPoint: ratioPoint,
          parent: dto.parent
        )
      })
    
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.skeletons = skeletons
  }
}

public struct Skeleton: Equatable, Decodable {
  public var name: String
  public var ratioPoint: RatioPoint
  public var parent: String?
  
  public init(name: String, ratioPoint: RatioPoint, parent: String? = nil) {
    self.name = name
    self.ratioPoint = ratioPoint
    self.parent = parent
  }
}

public struct RatioPoint: Equatable, Decodable {
  public var x: CGFloat
  public var y: CGFloat
  
  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }
}

public extension Joints {
  static func mockExample2() -> Self {
    return Self(dto: JointsDTO.example2Mock())
  }
}
//
//public extension Joints {
//  static func mockData() -> Self? {
//    do {
//      guard let jsonData = Self.mockJsonData() else {
//        return nil
//      }
//      let joints = try JSONDecoder().decode(Self.self, from: jsonData)
//      return joints
//    } catch let error {
//      print("Joints.mockData Error : \(error)")
//      return nil
//    }
//  }
//  
//  private static func mockJsonData() -> Data? {
//    return """
//{
//  "imageWidth" : 1000,
//  "imageHeight" : 1000,
//  "skeletons": {
//    "right_hip": {
//      "name": "right_hip",
//      "ratioPoint": {
//        "x": 0.3895582329317269,
//        "y": 0.7263843648208469
//      },
//      "parent": "root"
//    },
//    "torso": {
//      "name": "torso",
//      "ratioPoint": {
//        "x": 0.5522088353413654,
//        "y": 0.30456026058631924
//      },
//      "parent": "hip"
//    },
//    "neck": {
//      "name": "neck",
//      "ratioPoint": {
//        "x": 0.5582329317269076,
//        "y": 0.4201954397394137
//      },
//      "parent": "torso"
//    },
//    "right_hand": {
//      "name": "right_hand",
//      "ratioPoint": {
//        "x": 0.10240963855421686,
//        "y": 0.1986970684039088
//      },
//      "parent": "right_elbow"
//    },
//    "left_hip": {
//      "name": "left_hip",
//      "ratioPoint": {
//        "x": 0.7269076305220884,
//        "y": 0.7263843648208469
//      },
//      "parent": "root"
//    },
//    "right_knee": {
//      "name": "right_knee",
//      "ratioPoint": {
//        "x": 0.3634538152610442,
//        "y": 0.8322475570032574
//      },
//      "parent": "right_hip"
//    },
//    "left_hand": {
//      "name": "left_hand",
//      "ratioPoint": {
//        "x": 0.9236947791164659,
//        "y": 0.13517915309446255
//      },
//      "parent": "left_elbow"
//    },
//    "left_shoulder": {
//      "name": "left_shoulder",
//      "ratioPoint": {
//        "x": 0.8192771084337349,
//        "y": 0.28338762214983715
//      },
//      "parent": "torso"
//    },
//    "left_knee": {
//      "name": "left_knee",
//      "ratioPoint": {
//        "x": 0.7530120481927711,
//        "y": 0.8224755700325733
//      },
//      "parent": "left_hip"
//    },
//    "hip": {
//      "name": "hip",
//      "ratioPoint": {
//        "x": 0.5582329317269076,
//        "y": 0.7263843648208469
//      },
//      "parent": "root"
//    },
//    "right_foot": {
//      "name": "right_foot",
//      "ratioPoint": {
//        "x": 0.3373493975903614,
//        "y": 0.9495114006514658
//      },
//      "parent": "right_knee"
//    },
//    "root": {
//      "name": "root",
//      "ratioPoint": {
//        "x": 0.5582329317269076,
//        "y": 0.7263843648208469
//      }
//    },
//    "left_foot": {
//      "name": "left_foot",
//      "ratioPoint": {
//        "x": 0.7931726907630522,
//        "y": 0.9283387622149837
//      },
//      "parent": "left_knee"
//    },
//    "right_shoulder": {
//      "name": "right_shoulder",
//      "ratioPoint": {
//        "x": 0.285140562248996,
//        "y": 0.3257328990228013
//      },
//      "parent": "torso"
//    },
//    "left_elbow": {
//      "name": "left_elbow",
//      "ratioPoint": {
//        "x": 0.8714859437751004,
//        "y": 0.21009771986970685
//      },
//      "parent": "left_shoulder"
//    },
//    "right_elbow": {
//      "name": "right_elbow",
//      "ratioPoint": {
//        "x": 0.19477911646586346,
//        "y": 0.252442996742671
//      },
//      "parent": "right_shoulder"
//    }
//  }
//}
//""".data(using: .utf8)
//  }
//}

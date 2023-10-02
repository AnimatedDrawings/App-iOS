//
//  JointsDTO.swift
//  DTO
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct JointsDTO: Codable, Equatable {
  public var width: Int
  public var height: Int
  public var skeletonDTO: [SkeletonDTO]
  
  public init(width: Int, height: Int, skeletonDTO: [SkeletonDTO]) {
    self.width = width
    self.height = height
    self.skeletonDTO = skeletonDTO
  }
  
  enum CodingKeys: String, CodingKey {
    case width
    case height
    case skeletonDTO = "skeleton"
  }
}

public struct SkeletonDTO: Codable, Equatable {
  public var name: String
  public var location: [Int]
  public var parent: String?
  
  public init(name: String, location: [Int], parent: String? = nil) {
    self.name = name
    self.location = location
    self.parent = parent
  }
  
  enum CodingKeys: String, CodingKey {
    case name
    case location = "loc"
    case parent
  }
}

extension JointsDTO {
  public static func mockJointsDTO() -> JointsDTO? {
    do {
      guard let jsonData = makeMockData() else {
        return nil
      }
      let jointsModel = try JSONDecoder().decode(JointsDTO.self, from: jsonData)
      return jointsModel
    } catch let error {
      print("에러 : \(error)")
      return nil
    }
  }
  
  private static func makeMockData() -> Data? {
    return """
    {
      "height": 614,
      "skeleton": [
        {
          "loc": [
            278,
            446
          ],
          "name": "root",
          "parent": null
        },
        {
          "loc": [
            278,
            446
          ],
          "name": "hip",
          "parent": "root"
        },
        {
          "loc": [
            275,
            187
          ],
          "name": "torso",
          "parent": "hip"
        },
        {
          "loc": [
            278,
            258
          ],
          "name": "neck",
          "parent": "torso"
        },
        {
          "loc": [
            142,
            200
          ],
          "name": "right_shoulder",
          "parent": "torso"
        },
        {
          "loc": [
            97,
            155
          ],
          "name": "right_elbow",
          "parent": "right_shoulder"
        },
        {
          "loc": [
            51,
            122
          ],
          "name": "right_hand",
          "parent": "right_elbow"
        },
        {
          "loc": [
            408,
            174
          ],
          "name": "left_shoulder",
          "parent": "torso"
        },
        {
          "loc": [
            434,
            129
          ],
          "name": "left_elbow",
          "parent": "left_shoulder"
        },
        {
          "loc": [
            460,
            83
          ],
          "name": "left_hand",
          "parent": "left_elbow"
        },
        {
          "loc": [
            194,
            446
          ],
          "name": "right_hip",
          "parent": "root"
        },
        {
          "loc": [
            181,
            511
          ],
          "name": "right_knee",
          "parent": "right_hip"
        },
        {
          "loc": [
            168,
            583
          ],
          "name": "right_foot",
          "parent": "right_knee"
        },
        {
          "loc": [
            362,
            446
          ],
          "name": "left_hip",
          "parent": "root"
        },
        {
          "loc": [
            375,
            505
          ],
          "name": "left_knee",
          "parent": "left_hip"
        },
        {
          "loc": [
            395,
            570
          ],
          "name": "left_foot",
          "parent": "left_knee"
        }
      ],
      "width": 498
    }
    """.data(using: .utf8)
  }
}


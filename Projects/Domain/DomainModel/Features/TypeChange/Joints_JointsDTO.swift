//
//  Joints_JointsDTO.swift
//  Domain_Model
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import NetworkStorage

public extension JointsDTO {
  func toDomain() -> Joints {
    let imageWidth = CGFloat(self.width)
    let imageHeight = CGFloat(self.height)
    
    return Joints(
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      skeletons: self.skeletonDTO
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
    )
  }
}

public extension Joints {
  func toDTO() -> JointsDTO {
    return JointsDTO(
      width: Int(self.imageWidth),
      height: Int(self.imageHeight),
      skeletonDTO: self.skeletons.map { _, skeleton in
        let locationX = Int(skeleton.ratioPoint.x * self.imageWidth)
        let locationY = Int(skeleton.ratioPoint.y * self.imageHeight)
        
        return SkeletonDTO(
          name: skeleton.name,
          location: [locationX, locationY],
          parent: skeleton.parent
        )
      }
    )
  }
}

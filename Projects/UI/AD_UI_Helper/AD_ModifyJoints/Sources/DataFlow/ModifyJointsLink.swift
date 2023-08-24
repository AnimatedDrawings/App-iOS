//
//  ModifyJointsLink.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import Combine

class ModifyJointsLink: ObservableObject {
//  @Published var jointsInfo: JointsInfo
//  var startSave = PassthroughSubject<Void, Never>()
//  @Published var finishSave = false
//
//  @Published var currentJoint: String? = nil
//  var originData: [String : CGPoint]
//  var modifiedJointsDTO: JointsDTO
//  let originalDTOSize: CGSize
  
//  var anyCancellable = Set<AnyCancellable>()
  
  @Published var jointsInfo: JointsInfo
  @Published var viewSize: CGSize = .init()
  
  @Published var currentJoint: String? = nil
  let originSkeletons: [String : SkeletonInfo]
  
  init(jointsInfo: JointsInfo) {
    self.jointsInfo = jointsInfo
    self.originSkeletons = jointsInfo.skeletons
  }
  
//  init(jointsDTO: JointsDTO) {
//    self._jointsInfo = Published(initialValue: jointsDTO.toDomain())
//    self.modifiedJointsDTO = jointsDTO
//    self.originalDTOSize = CGSize(width: jointsDTO.width, height: jointsDTO.height)
//
//    let cgWidth = CGFloat(jointsDTO.width)
//    let cgHeight = CGFloat(jointsDTO.height)
//    self.originData = jointsDTO.skeletonDTO.reduce(into: [String : CGPoint]()) { dict, dto in
//      let ratioX: CGFloat = cgWidth == 0 ? 0 : CGFloat(dto.location[0]) / cgWidth
//      let ratioY: CGFloat = cgHeight == 0 ? 0 : CGFloat(dto.location[1]) / cgHeight
//
//      dict[dto.name] = CGPoint(x: ratioX, y: ratioY)
//    }
//
//    self.startSave.sink { [weak self] _ in
//      guard let `self` = self else {
//        return
//      }
//
//      self.modifiedJointsDTO = self.jointsInfo.toData(originalDTOSize: originalDTOSize)
//      // put any save logic
//
//      `self`.finishSave.toggle()
//    }
//    .store(in: &self.anyCancellable)
//
//    self.jointsInfo.objectWillChange.sink { [weak self] _ in
//      guard let `self` = self else {
//        return
//      }
//
//      `self`.objectWillChange.send()
//    }
//    .store(in: &self.anyCancellable)
//  }
}

extension ModifyJointsLink {
//  func resetSkeletonRatio() {
//    self.originData.forEach { name, cgPoint in
//      guard let curSkeletonInfo = self.jointsInfo.skeletonInfo[name] else {
//        return
//      }
//      curSkeletonInfo.ratioPoint = cgPoint
//    }
//  }
  
//  func resetSkeletonRatio() {
  func resetSkeletons() {
    self.jointsInfo.skeletons = self.originSkeletons
//    self.originSkeletons.forEach { name, cgPoint in
//      guard let curSkeletonInfo = self.jointsInfo.skeletons[name] else {
//        return
//      }
//      curSkeletonInfo.ratioPoint = cgPoint
//    }
  }
}

//extension JointsDTO {
//  func toDomain() -> JointsInfo {
//    let cgWidth = CGFloat(self.width)
//    let cgHeight = CGFloat(self.height)
//
//    return JointsInfo(
//      viewSize: CGSize(width: cgWidth, height: cgHeight),
//      skeletonInfo: self.skeletonDTO
//        .reduce(into: [String : SkeletonInfo]()) { dict, dto in
//          let ratioX: CGFloat = cgWidth == 0 ? 0 : CGFloat(dto.location[0]) / cgWidth
//          let ratioY: CGFloat = cgHeight == 0 ? 0 : CGFloat(dto.location[1]) / cgHeight
//
//          let skeletonInfo = SkeletonInfo(
//            name: dto.name,
//            ratioPoint: CGPoint(x: ratioX, y: ratioY),
//            parent: dto.parent
//          )
//
//          dict[dto.name] = skeletonInfo
//      }
//    )
//  }
//}

//extension JointsInfo {
//  func toData(originalDTOSize: CGSize) -> JointsDTO {
//    return JointsDTO(
//      width: Int(originalDTOSize.width),
//      height: Int(originalDTOSize.height),
//      skeletonDTO: self.skeletonInfo.map { _, skeletonInfo in
//        let locationX = Int(skeletonInfo.ratioPoint.x * originalDTOSize.width)
//        let locationY = Int(skeletonInfo.ratioPoint.y * originalDTOSize.height)
//
//        return SkeletonDTO(
//          name: skeletonInfo.name,
//          location: [locationX, locationY],
//          parent: skeletonInfo.parent
//        )
//      }
//    )
//  }
//}

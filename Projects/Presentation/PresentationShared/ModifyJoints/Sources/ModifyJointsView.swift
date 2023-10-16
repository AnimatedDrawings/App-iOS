//
//  ModifyJointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import ADUIKit
import DomainModel

public struct ModifyJointsView: View {
  let croppedImage: UIImage
  @StateObject var modifyJointsLink: ModifyJointsLink
  let modifyNextAction: (Joints) -> ()
  let cancel: () -> ()
  
  let strokeColor: Color = ADUIKitAsset.Color.blue1.swiftUIColor
  
  public init(
    croppedImage: UIImage,
    joints: Joints,
    modifyNextAction: @escaping (Joints) -> Void,
    cancel: @escaping () -> Void
  ) {
    self.croppedImage = croppedImage
    self._modifyJointsLink = StateObject(
      wrappedValue: ModifyJointsLink(
        joints: joints
      )
    )
    self.modifyNextAction = modifyNextAction
    self.cancel = cancel
  }
  
  public var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(cancelAction: cancel, saveAction: save)
      
      Spacer()
      
      VStack {
        JointName()
          .frame(height: 50)
        
        SkeletonView(
          croppedImage: croppedImage,
          modifyJointsLink: self.modifyJointsLink,
          strokeColor: strokeColor
        )
      }
      
      Spacer()
      
      HStack {
        Spacer()
        ResetButton()
      }
    }
    .padding()
  }
}

extension ModifyJointsView {
  func save() {
    let modifiedJoints = Joints(
      imageWidth: self.modifyJointsLink.imageWidth,
      imageHeight: self.modifyJointsLink.imageHeight,
      skeletons: self.modifyJointsLink.skeletons
    )
    self.modifyNextAction(modifiedJoints)
  }
}

extension ModifyJointsView {
  @ViewBuilder
  func JointName() -> some View {
    let jointNameColor: Color = ADUIKitAsset.Color.jointName.swiftUIColor
    let textInset: CGFloat = 5
    
    RoundedRectangle(cornerRadius: 10)
      .foregroundColor(jointNameColor)
      .padding(.vertical, textInset)
      .overlay {
        Text(jointNameDescription)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .lineLimit(1)
          .font(.system(size: 100))
          .minimumScaleFactor(0.001)
          .foregroundColor(.white)
          .padding(.horizontal, textInset)
      }
  }
  
  var jointNameDescription: String {
    if let name = self.modifyJointsLink.currentJoint {
      return name
    }
    return "Adjust by dragging the points"
  }
}

extension ModifyJointsView {
  @ViewBuilder
  func ResetButton() -> some View {
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    
    Button(action: resetAction) {
      Circle()
        .frame(width: size, height: size)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          Image(systemName: imageName)
            .resizable()
            .foregroundColor(strokeColor)
            .fontWeight(.semibold)
            .padding()
        }
    }
  }
  
  func resetAction() {
    self.modifyJointsLink.resetSkeletons()
  }
}

// MARK: - Previews_ModifyJointsView

public struct Previews_ModifyJointsView: View {
  let croppedImage: UIImage = ModifyJointsAsset.croppedGarlic.image
  let mockJoints = Joints.mockData()!
  
  public init () {}
  
  public var body: some View {
    ModifyJointsView(
      croppedImage: croppedImage,
      joints: mockJoints,
      modifyNextAction: { modifiedJointsInfo in
        
      },
      cancel: {}
    )
  }
}

struct ModifyJointsView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ModifyJointsView()
  }
}
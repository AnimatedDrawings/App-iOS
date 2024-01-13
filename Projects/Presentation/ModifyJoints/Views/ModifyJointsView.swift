//
//  ModifyJointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import ADUIKitSources
import ADUIKitResources
import DomainModel
import ThirdPartyLib
import ModifyJointsFeatures

public struct ModifyJointsView: ADUI {
  public typealias MyFeature = ModifyJointsFeature
  
  let croppedImage: UIImage
  @StateObject var modifyJointsLink: ModifyJointsLink
  let modifyNextAction: (Joints) -> ()
  let cancel: () -> ()
  
  @StateObject var viewStore: MyViewStore
  
  public init(
    croppedImage: UIImage,
    joints: Joints,
    modifyNextAction: @escaping (Joints) -> Void,
    cancel: @escaping () -> Void,
    store: MyStore
  ) {
    self.croppedImage = croppedImage
    self._modifyJointsLink = StateObject(
      wrappedValue: ModifyJointsLink(
        joints: joints
      )
    )
    self.modifyNextAction = modifyNextAction
    self.cancel = cancel
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  public var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        cancelAction: viewStore.action(.cancelAction),
        saveAction: viewStore.action(.saveAction)
      )
      
      Spacer()
      
      VStack {
        JointName(viewStore.currentJoint)
          .frame(height: 50)
        
        SkeletonView(
          croppedImage: croppedImage,
          modifyJointsLink: self.modifyJointsLink
        )
      }
      
      Spacer()
      
      HStack {
        Spacer()
        ResetButton(action: viewStore.action(.resetSkeletons))
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
//  @ViewBuilder
//  func JointName() -> some View {
//    let jointNameColor: Color = ADUIKitResourcesAsset.Color.jointName.swiftUIColor
//    let textInset: CGFloat = 5
//    
//    RoundedRectangle(cornerRadius: 10)
//      .foregroundColor(jointNameColor)
//      .padding(.vertical, textInset)
//      .overlay {
//        Text(jointNameDescription)
//          .frame(maxWidth: .infinity, maxHeight: .infinity)
//          .lineLimit(1)
//          .font(.system(size: 100))
//          .minimumScaleFactor(0.001)
//          .foregroundColor(.white)
//          .padding(.horizontal, textInset)
//      }
//  }
  
//  var jointNameDescription: String {
//    if let name = self.modifyJointsLink.currentJoint {
//      return name
//    }
//    return "Adjust by dragging the points"
//  }
  
  struct JointName: View {
    let jointNameColor: Color = ADUIKitResourcesAsset.Color.jointName.swiftUIColor
    let textInset: CGFloat = 5
    let name: String?
    
    init(_ name: String?) {
      self.name = name
    }
    
    var body: some View {
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(jointNameColor)
        .padding(.vertical, textInset)
        .overlay {
          Text(name ?? "Adjust by dragging the points")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .lineLimit(1)
            .font(.system(size: 100))
            .minimumScaleFactor(0.001)
            .foregroundColor(.white)
            .padding(.horizontal, textInset)
        }
    }
  }
}

extension ModifyJointsView {
  struct ResetButton: View {
    let color: Color = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    let action: () -> ()
    
    var body: some View {
      Button(action: action) {
        Circle()
          .frame(width: size, height: size)
          .foregroundColor(.white)
          .shadow(radius: 10)
          .overlay {
            Image(systemName: imageName)
              .resizable()
              .foregroundColor(color)
              .fontWeight(.semibold)
              .padding()
          }
      }
    }
  }
  
//  @ViewBuilder
//  func ResetButton() -> some View {
//    let size: CGFloat = 60
//    let imageName = "arrow.uturn.backward"
//    
//    Button(action: resetAction) {
//      Circle()
//        .frame(width: size, height: size)
//        .foregroundColor(.white)
//        .shadow(radius: 10)
//        .overlay {
//          Image(systemName: imageName)
//            .resizable()
//            .foregroundColor(strokeColor)
//            .fontWeight(.semibold)
//            .padding()
//        }
//    }
//  }
//  
//  func resetAction() {
//    self.modifyJointsLink.resetSkeletons()
//  }
}


// MARK: - Preview

#Preview {
  Previews_ModifyJointsView()
}


public struct Previews_ModifyJointsView: View {
  let croppedImage: UIImage = ADUIKitResourcesAsset.TestImages.croppedImage.image
  let mockJoints = Joints.mockData()!
  
  public init () {}
  
  public var body: some View {
    ModifyJointsView(
      croppedImage: croppedImage,
      joints: mockJoints,
      modifyNextAction: { modifiedJointsInfo in
        
      },
      cancel: {},
      store: Store(initialState: .init(), reducer: { ModifyJointsFeature() })
    )
  }
}

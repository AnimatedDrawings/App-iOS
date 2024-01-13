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
  @StateObject var viewStore: MyViewStore
  
  let croppedImage: UIImage
  let save: (Joints) -> ()
  let cancel: () -> ()
  
  public init(
    croppedImage: UIImage,
    joints: Joints,
    save: @escaping (Joints) -> (),
    cancel: @escaping () -> ()
  ) {
    self.croppedImage = croppedImage
    self.save = save
    self.cancel = cancel
    let store: MyStore = Store(initialState: .init(joints: joints)) {
      ModifyJointsFeature()
    }
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  public var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        cancelAction: cancelAction,
        saveAction: saveAction
      )
      
      Spacer()
      
      VStack {
        JointName(viewStore.currentJoint)
          .frame(height: 50)
        
        SkeletonView(
          croppedImage: croppedImage,
          viewStore: viewStore
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
  func saveAction() {
    let modifiedJoints = Joints(
      imageWidth: viewStore.imageWidth,
      imageHeight: viewStore.imageHeight,
      skeletons: viewStore.skeletons
    )
    self.save(modifiedJoints)
  }
  
  func cancelAction() {
    self.cancel()
  }
}

extension ModifyJointsView {
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
      save: { _ in },
      cancel: {}
    )
  }
}

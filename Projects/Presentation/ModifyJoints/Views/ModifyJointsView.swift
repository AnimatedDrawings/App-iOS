//
//  ModifyJointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import ADUIKit
import ADComposableArchitecture
import ADResources
import ModifyJointsFeatures
import DomainModels

public struct ModifyJointsView: View {
  @Perception.Bindable var store: StoreOf<ModifyJointsFeature>
  @State var currentJointName: String? = nil
  @State var skeletons: [String : Skeleton] = [:]
  let croppedImage: UIImage
  
  public init(store: StoreOf<ModifyJointsFeature>) {
    self.store = store
    self.croppedImage = store.croppedImage
    self._skeletons = State(initialValue: store.originJoints.skeletons)
  }
  
  public var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        cancelAction: store.action(.view(.cancel)),
        saveAction: store.action(.view(.save(skeletons)))
      )
      
      Spacer()
      
      VStack {
        JointName(currentJointName)
          .frame(height: 50)
        
        SkeletonView(
          skeletons: $skeletons,
          currentJointName: $currentJointName,
          croppedImage: croppedImage
        )
      }
      
      Spacer()
      
      HStack {
        Spacer()
        ResetButton(action: resetAction)
      }
    }
    .padding()
  }
}

extension ModifyJointsView {
  struct JointName: View {
    let name: String?
    let jointNameColor: Color = ADResourcesAsset.Color.jointName.swiftUIColor
    let textInset: CGFloat = 5
    
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
  func resetAction() {
    skeletons = store.originJoints.skeletons
  }
  
  struct ResetButton: View {
    let action: () -> ()
    let color: Color = ADResourcesAsset.Color.blue1.swiftUIColor
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    
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


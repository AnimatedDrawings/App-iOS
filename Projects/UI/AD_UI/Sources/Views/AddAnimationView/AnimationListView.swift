//
//  AnimationListView.swift
//  AD_UI
//
//  Created by minii on 2023/08/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils
import AD_Feature

struct AnimationListView: View {
  let tapAnimationItemAction: (ADAnimation) -> ()
  
  @State var selectedCategory: AnimationCategory = .ALL
  @State var animationList: [ADAnimation] = []
  @State var gridItemHeight: CGFloat = 0
  
  let strokeColor: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  
  var body: some View {
    VStack {
      Spacer().frame(height: 20)
      SegmentView()
      Spacer().frame(height: 40)
      AnimationGridView()
    }
    .padding()
  }
}

extension AnimationListView {
  @ViewBuilder
  func SegmentView() -> some View {
    HStack {
      ForEach(AnimationCategory.allCases, id: \.rawValue) { item in
        Category(item)
          .frame(width: 100)
      }
      Spacer()
    }
  }
  
  @ViewBuilder
  func Category(_ myType: AnimationCategory) -> some View {
    Button {
      self.selectedCategory = myType
    } label: {
      RoundedRectangle(cornerRadius: 20)
        .stroke(strokeColor, lineWidth: 3)
        .background(
          RoundedRectangle(cornerRadius: 25)
            .foregroundColor(self.selectedCategory == myType ? strokeColor : .white)
        )
        .frame(height: 40)
        .overlay {
          Text(myType.rawValue)
            .font(.title2)
            .foregroundColor(self.selectedCategory == myType ? .white : strokeColor)
        }
    }
  }
}

extension AnimationListView {
  @ViewBuilder
  func AnimationGridView() -> some View {
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 3)
    
    ScrollView {
      LazyVGrid(columns: columns) {
        if let firstAnimationItem = firstAnimationItem {
          AnimationGridItem(firstAnimationItem)
            .background(
              GeometryReader { geo in
                Color.clear
                  .onAppear {
                    self.gridItemHeight = geo.size.width
                  }
              }
            )
        }
        
        ForEach(restAnimationItem, id: \.rawValue) { item in
          AnimationGridItem(item)
        }
        
      }
    }
  }
  
  var firstAnimationItem: ADAnimation? {
    return 0 < selectedCategory.animations.count ?
    selectedCategory.animations[0] :
    nil
  }
  
  var restAnimationItem: [ADAnimation] {
    return Array(selectedCategory.animations.dropFirst())
  }
  
  @ViewBuilder
  func AnimationGridItem(_ adAnimation: ADAnimation) -> some View {
    Button {
      self.tapAnimationItemAction(adAnimation)
    } label: {
      RoundedRectangle(cornerRadius: 15)
        .stroke(strokeColor, lineWidth: 3)
        .cornerRadius(15)
        .frame(height: self.gridItemHeight)
        .overlay {
          Text(adAnimation.rawValue)
            .font(.title2)
            .foregroundColor(strokeColor)
        }
    }
  }
}

enum AnimationCategory: String, CaseIterable {
  case ALL
  case DANCE
  case FUNNY
  
  var animations: [ADAnimation] {
    switch self {
    case .ALL:
      return ADAnimation.allCases
    case .DANCE:
      return [.dab]
    case .FUNNY:
      return [.zombie]
    }
  }
}

struct AnimationListView_Previews: PreviewProvider {
  static var previews: some View {
    AnimationListView { _ in }
  }
}

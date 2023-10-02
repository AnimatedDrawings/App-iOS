//
//  AnimationListView.swift
//  AD_UI
//
//  Created by minii on 2023/08/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_UIKit
import Domain_Model

struct AnimationListView: View {
  @Binding var isShowMyView: Bool
  let tapAnimationItemAction: (ADAnimation) -> ()
  
  init(
    isShow: Binding<Bool>,
    tapAnimationItemAction: @escaping (ADAnimation) -> Void
  ) {
    self._isShowMyView = isShow
    self.tapAnimationItemAction = tapAnimationItemAction
  }
  
  @State var selectedCategory: AnimationCategory = .ALL
  @State var gridItemHeight: CGFloat = 0
  
  let strokeColor: Color = ADUIKitAsset.Color.blue1.swiftUIColor
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        CancelButton {
          self.isShowMyView.toggle()
        }
      }
      .padding(.horizontal)
      ScrollView {
        Title()
          .padding(.horizontal)
        LazyVStack(spacing: 20, pinnedViews: .sectionHeaders) {
          Section {
            AnimationGridView()
          } header: {
            SegmentView()
          }
        }
        .padding()
      }
      .scrollDisabled(true)
    }
  }
}

extension AnimationListView {
  @ViewBuilder
  func CancelButton(action: @escaping () -> ()) -> some View {
    let imageName = "x.circle"
    
    Button(action: action) {
      Image(systemName: imageName)
        .resizable()
        .frame(width: 40, height: 40)
        .aspectRatio(contentMode: .fit)
        .fontWeight(.semibold)
        .foregroundColor(strokeColor)
    }
  }
}

extension AnimationListView {
  @ViewBuilder
  func Title() -> some View {
    let title = "ADD ANIMATION"
    let description = "Choose one of the motions by tapping human button to see your character perform it!"
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(strokeColor)
      
      Text(description)
        .frame(maxWidth: .infinity)
    }
  }
}

extension AnimationListView {
  @ViewBuilder
  func SegmentView() -> some View {
    HStack {
      ForEach(AnimationCategory.allCases, id: \.rawValue) { item in
        Category(myCategory: item, selectedCategory: self.$selectedCategory)
      }
      Spacer()
    }
  }
  
  struct Category: View {
    let myCategory: AnimationCategory
    @Binding var selectedCategory: AnimationCategory
    
    @State var myWidth: CGFloat = 0
    let strokeColor: Color = ADUIKitAsset.Color.blue1.swiftUIColor
    
    var body: some View {
      Button {
        self.selectedCategory = myCategory
      } label: {
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .stroke(strokeColor, lineWidth: 3)
            .background(
              RoundedRectangle(cornerRadius: 25)
                .foregroundColor(self.selectedCategory == myCategory ? strokeColor : .white)
            )
            .frame(width: self.myWidth, height: 40)
          
          Text(myCategory.rawValue)
            .font(.title3)
            .foregroundColor(self.selectedCategory == myCategory ? .white : strokeColor)
            .background(
              GeometryReader { geo in
                Color.clear
                  .onAppear {
                    self.myWidth = geo.size.width + 20
                  }
              }
            )
        }
      }
    }
  }
}

extension AnimationListView {
  @ViewBuilder
  func AnimationGridView() -> some View {
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 3)
    
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
  
  var firstAnimationItem: ADAnimation? {
    self.selectedCategory.animations.first
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
          GIFImage(gifData: adAnimation.gifData)
            .frame(width: gifViewSize, height: gifViewSize)
        }
    }
  }
  
  var gifViewSize: CGFloat {
    max(0, self.gridItemHeight - 10)
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

struct Previews_AnimationListView: View {
  @State var isShow = false
  
  var body: some View {
    AnimationListView(isShow: $isShow) { _ in
    }
  }
}

struct AnimationListView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_AnimationListView()
  }
}

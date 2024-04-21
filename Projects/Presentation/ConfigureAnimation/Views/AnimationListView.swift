//
//  AnimationListView.swift
//  AD_UI
//
//  Created by minii on 2023/08/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKit
import ADResources
import DomainModels

struct AnimationListView: View {
  @Binding var popViewState: Bool
  let selectAnimationItem: (ADAnimation) -> ()
  
  init(
    popViewState: Binding<Bool>,
    selectAnimationItem: @escaping (ADAnimation) -> Void
  ) {
    self._popViewState = popViewState
    self.selectAnimationItem = selectAnimationItem
  }
  
  @State var selectedCategory: AnimationCategory = .ALL
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        CancelButton {
          self.popViewState.toggle()
        }
      }
      .padding(.horizontal)
      
      ScrollView {
        Title()
          .padding(.horizontal)
        LazyVStack(spacing: 20, pinnedViews: .sectionHeaders) {
          Section {
            AnimationGridView(
              selectedCategory: $selectedCategory,
              tapAnimationItemAction: selectAnimationItem
            )
          } header: {
            SegmentView(selectedCategory: $selectedCategory)
          }
        }
        .padding()
      }
      .scrollDisabled(true)
    }
  }
}

private extension AnimationListView {
  struct CancelButton: View {
    let imageName = "x.circle"
    let strokeColor: Color = ADResourcesAsset.Color.blue1.swiftUIColor
    
    let action: () -> ()
    
    var body: some View {
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
}

private extension AnimationListView {
  struct Title: View {
    let title = "ADD ANIMATION"
    let description = "Choose one of the motions by tapping human button to see your character perform it!"
    let strokeColor: Color = ADResourcesAsset.Color.blue1.swiftUIColor
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.largeTitle, weight: .semibold))
          .foregroundColor(strokeColor)
        
        Text(description)
          .frame(maxWidth: .infinity)
      }
    }
  }
}

private extension AnimationListView {
  struct SegmentView: View {
    @Binding var selectedCategory: AnimationCategory
    
    var body: some View {
      HStack {
        ForEach(AnimationCategory.allCases, id: \.rawValue) { item in
          AnimationListView.Category(
            myCategory: item,
            selectedCategory: $selectedCategory
          )
        }
        Spacer()
      }
    }
  }
  
  struct Category: View {
    let myCategory: AnimationCategory
    @Binding var selectedCategory: AnimationCategory
    
    @State var myWidth: CGFloat = 0
    let strokeColor: Color = ADResourcesAsset.Color.blue1.swiftUIColor
    
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

private extension AnimationListView {
  struct AnimationGridView: View {
    let strokeColor: Color = ADResourcesAsset.Color.blue1.swiftUIColor
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 3)
    @State var gridItemSize: CGFloat = 1
    
    @Binding var selectedCategory: AnimationCategory
    let tapAnimationItemAction: (ADAnimation) -> ()
    
    var firstAnimationItem: ADAnimation? {
      self.selectedCategory.animations.first
    }
    var restAnimationItem: [ADAnimation] {
      return Array(selectedCategory.animations.dropFirst())
    }
    var gifViewSize: CGFloat {
      max(0, self.gridItemSize - 10)
    }
    
    @ViewBuilder
    func AnimationGridItem(_ adAnimation: ADAnimation) -> some View {
      Button {
        self.tapAnimationItemAction(adAnimation)
      } label: {
        RoundedRectangle(cornerRadius: 15)
          .stroke(strokeColor, lineWidth: 3)
          .cornerRadius(15)
          .frame(height: self.gridItemSize)
          .overlay {
            GIFImage(gifData: adAnimation.gifData)
              .frame(width: gifViewSize)
          }
      }
    }
    
    var body: some View {
      LazyVGrid(columns: columns) {
        if let firstAnimationItem = firstAnimationItem {
          AnimationGridItem(firstAnimationItem)
            .background(
              GeometryReader { geo in
                Color.clear
                  .onAppear {
                    self.gridItemSize = geo.size.width
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

private extension ADAnimation {
  var gifData: Data {
    switch self {
    case .dab:
      return ADResourcesAsset.ADAnimation.dab.data.data
    case .zombie:
      return ADResourcesAsset.ADAnimation.zombie.data.data
    }
  }
}

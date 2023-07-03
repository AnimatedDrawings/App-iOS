//
//  MaskImageView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct MaskImageView: View {
  let croppedImage: UIImage
  let verticalInset: CGFloat = 20
  
  init(croppedImage: UIImage) {
    self.croppedImage = croppedImage
  }
  
  var body: some View {
    VStack(spacing: verticalInset) {
      VStack(spacing: verticalInset) {
        Image(uiImage: croppedImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .foregroundColor(.gray.opacity(0.1))
      )
      
      MaskToolView(verticalInset: verticalInset)
      
      HStack {
        ADButton("Previous", .inActive) {
          print("previous..")
        }
        
        ADButton("Next") {
          print("mask image")
        }
      }
    }
    .padding()
  }
}

struct MaskToolView: View {
  let verticalInset: CGFloat
  let strokeColor: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  @State var height: CGFloat = 0
  let spacing: CGFloat = 5
  
  var body: some View {
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: verticalInset) {
        HStack(spacing: spacing) {
          Marker()
          Eraser()
          ToolSizer()
        }
        
        HStack(spacing: spacing) {
          Undo()
          Reset()
        }
      }
      .onAppear {
        self.height = (geo.size.width - (spacing * 4)) / 5
      }
    }
    .frame(height: self.height * 2 + verticalInset)
  }
}

extension MaskToolView {
  @ViewBuilder
  func Marker() -> some View {
    Button {
      
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .stroke(strokeColor)
          .frame(width: self.height, height: self.height)
        
        Image(systemName: "pencil")
          .foregroundColor(strokeColor)
          .font(.title)
      }
    }
  }
  
  @ViewBuilder
  func Eraser() -> some View {
    Button {
      
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .stroke(strokeColor)
          .frame(width: self.height, height: self.height)
        
        Image(systemName: "eraser.fill")
          .foregroundColor(strokeColor)
          .font(.title)
      }
    }
  }
  
  @ViewBuilder
  func ToolSizer() -> some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(strokeColor)
      .frame(width: self.height * 3, height: self.height)
      .overlay {
        GeometryReader { geo in
          let maxHeight: CGFloat = geo.size.height - 20
          
          VStack {
            HStack(spacing: 15) {
              ForEach(1...4, id: \.self) { index in
                let tmpIndex = CGFloat(4 - index)
                let dist: CGFloat = tmpIndex * 12
                Circle()
                // 안으로 들어가게 stroke
                  .stroke(strokeColor, lineWidth: CGFloat(index * 2))
                  .frame(width: maxHeight - dist, height: maxHeight - dist)
              }
            }
            .frame(maxWidth: .infinity, alignment: .center)
          }
          .frame(maxHeight: .infinity, alignment: .center)
        }
      }
  }
  
  @ViewBuilder
  func Undo() -> some View {
    Button {
      
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .stroke(strokeColor)
          .frame(width: self.height, height: self.height)
        
        Image(systemName: "arrow.uturn.backward")
          .foregroundColor(strokeColor)
          .font(.title)
      }
    }
  }
  
  @ViewBuilder
  func Reset() -> some View {
    Button {
      
    } label: {
      RoundedRectangle(cornerRadius: 10)
        .stroke(strokeColor)
        .frame(width: self.height * 2, height: self.height)
        .overlay {
          Text("Reset Mask")
            .foregroundColor(strokeColor)
            .font(.title3)
        }
    }
  }
}

struct PreviewsMaskToolView: View {
  let croppedImage: UIImage = ADUtilsAsset.SampleDrawing.example1.image
  
  var body: some View {
    MaskImageView(croppedImage: croppedImage)
  }
}

struct MaskImageView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsMaskToolView()
  }
}

//
//  MaskingImageView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/04.
//

import SwiftUI
import Combine
import AD_Utils

struct MaskingImageView: View {
  let croppedImage: UIImage
  let backgroundImage: UIImage = ADUtilsAsset.SampleDrawing.checkerboard.image
  
  @StateObject var maskToolState = MaskToolState()
  @StateObject var maskableViewLink = MaskableViewLink()
  
  @State var imageFrame: CGRect = .init()
  @State var toolSizerButtonOffset: CGFloat = 0
  @State var reloadTrigger: Bool = false
  
  let cancelAction: () -> ()
  
  var body: some View {
    VStack {
      ToolNaviBar(
        cancelAction: cancel,
        saveAction: save
      )
      .padding()
      
      Spacer()
      
      Image(uiImage: backgroundImage)
        .resizable()
        .frame(height: 450)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                self.imageFrame = geo.frame(in: .global)
                self.reloadTrigger.toggle()
              }
          }
        )
        .overlay {
          MaskableUIViewRepresentable(
            myFrame: imageFrame,
            croppedImage: croppedImage,
            maskToolState: maskToolState,
            maskableViewLink: maskableViewLink
          )
        }
        .padding()
        .reload(reloadTrigger)
      
      Spacer()
      Spacer()
        .frame(height: toolSizerButtonOffset)
      
      MaskToolView(
        maskToolState: maskToolState,
        toolSizerButtonOffset: $toolSizerButtonOffset
      )
    }
//    .toolbar {
//      ToolbarItem(placement: .navigationBarTrailing) {
//        Button {
//          self.maskableViewLink.startMasking.toggle()
//        } label: {
//          Image(systemName: "square.and.arrow.down")
//            .resizable()
//            .font(.title2)
//            .fontWeight(.semibold)
//            .foregroundColor(.black)
//        }
//      }
//    }
//    .navigationDestination(
//      isPresented: self.$maskableViewLink.finishMasking
//    ) {
//      MaskedImageView(maskedImage: self.maskableViewLink.maskedImage)
//    }
  }
}

extension MaskingImageView {
  func cancel() {
    cancelAction()
  }
}

extension MaskingImageView {
  func save() {
    
  }
}

struct Previews_MaskingImageView: View {
  let croppedImage: UIImage = ADUtilsAsset.SampleDrawing.garlicCropped.image
  
  var body: some View {
    MaskingImageView(
      croppedImage: croppedImage,
      cancelAction: {
        print("cancelAction")
      })
  }
}

struct MaskableView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_MaskingImageView()
  }
}


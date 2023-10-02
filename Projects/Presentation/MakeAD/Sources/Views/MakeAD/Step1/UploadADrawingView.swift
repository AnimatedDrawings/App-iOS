//
//  UploadADrawingView.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_UIKit
import ThirdPartyLib
import MakeAD_Feature
import PhotosUI
import Domain_Model
import SharedProvider

struct UploadADrawingView: ADUI {
  typealias MyFeature = UploadADrawingFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: MyStore = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
  }
  
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
//          CheckList(
//            isCorrectStep: Step.isCorrectStep(
//              myStep: .UploadADrawing,
//              completeStep: completeStep
//            )
//          ) {
//            VStack {
//              //              TextView(text: "efoheioghe")
//              CheckListContent(with: store)
//            }
//          }
          
          CheckList(myStep: .UploadADrawing) {
            CheckListContent(with: store)
          }
          
          UploadButton(viewStore.isEnableUploadButton) { imageData in
            viewStore.send(.uploadDrawing(imageData))
          }
          
          SampleDrawings { imageData in
            viewStore.send(.uploadDrawing(imageData))
          }
          
          Spacer()
        }
        .padding()
        .fullScreenOverlay(presentationSpace: .named("UploadADrawingView")) {
          WithViewStore(store, observe: { $0 }) { viewStore in
            if viewStore.state.isShowLoadingView {
              LoadingView(description: "Uploading Drawing...")
                .transparentBlurBackground(
                  effect: UIBlurEffect(style: .light),
                  intensity: 0.3
                )
            }
          }
        }
        .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
      }
    }
  }
}

//
//struct TextView: View {
//  let store: StoreOf<UploadADrawingFeature>
//  let text: String
//
//  var body: some View {
//    let _ = Self._printChanges()
//
//    Text(text)
//      .font(.largeTitle)
//      .frame(maxWidth: .infinity)
//      .frame(height: 200)
//      .randomBackground()
//  }
//}

//extension View {
//  func randomBackground() -> some View {
//    self.background(Color.random)
//  }
//}
//
//extension Color {
//  static var random: Color {
//    return Color(
//      red: .random(in: 0...1),
//      green: .random(in: 0...1),
//      blue: .random(in: 0...1)
//    )
//  }
//}

extension UploadADrawingView {
  private struct Title: View {
    let title = "UPLOAD A DRAWING"
    let left = "Upload a drawing of"
    let one = " ONE "
    let right = "character, where the arms and legs don’t overlap the body (see examples below)."
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
        
        Text(left) + Text(one).fontWeight(.bold) + Text(right)
      }
    }
  }
}

extension UploadADrawingView {
  private struct CheckListContent: View {
    let store: MyStore
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    
    init(with store: MyStore) {
      self.store = store
    }
    
    var body: some View {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(alignment: .leading, spacing: 15) {
          CheckListButton(description1, state: viewStore.checkState1) {
            viewStore.send(.checkList1)
          }
          
          CheckListButton(description2, state: viewStore.checkState2) {
            viewStore.send(.checkList2)
          }
          
          CheckListButton(description3, state: viewStore.checkState3) {
            viewStore.send(.checkList3)
          }
        }
        .onChange(of: viewStore.checkState1) { newValue in
          print(newValue)
        }
      }
    }
  }
}

extension UploadADrawingView {
  
  //  UploadButton(viewStore.isEnableUploadButton) { imageData in
  //    viewStore.send(.uploadDrawing(imageData))
  //  }
  
  //  private struct UploadButton: View {
  //    let store: MyStore
  //
  //    init(with store: MyStore) {
  //      self.store = store
  //    }
  //
  //    @State private var selectedItem: PhotosPickerItem? = nil
  //    let photoFill = "photo.fill"
  //    let text = "Upload Photo"
  //
  //    var body: some View {
  //      let _ = Self._printChanges()
  //
  //      WithViewStore(store, observe: { $0 }) { viewStore in
  //        PhotosPicker(
  //          selection: $selectedItem,
  //          photoLibrary: .shared(),
  //          label: {
  //            ADButtonLabel(viewStore.isEnableUploadButton ? .active : .inActive) {
  //              HStack {
  //                Image(systemName: photoFill)
  //                Text(text)
  //              }
  //            }
  //          }
  //        )
  //        .onChange(of: selectedItem) { newItem in
  //          _Concurrency.Task {
  //            let data = try? await newItem?.loadTransferable(type: Data.self)
  //            viewStore.send(.uploadDrawing(data))
  //          }
  //        }
  //        .allowsHitTesting(viewStore.isEnableUploadButton)
  //      }
  //    }
  //  }
  
  struct UploadButton: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    var state: Bool
    var uploadImageAction: (Data?) -> ()
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    var buttonState: ADButtonState {
      self.state == true ? .active : .inActive
    }
    
    init(_ state: Bool,
         uploadImageAction: @escaping (Data?) -> ()
    ) {
      self.state = state
      self.uploadImageAction = uploadImageAction
    }
    
    var body: some View {
      PhotosPicker(
        selection: $selectedItem,
        photoLibrary: .shared(),
        label: {
          ADButtonLabel(buttonState) {
            HStack {
              Image(systemName: photoFill)
              Text(text)
            }
          }
        }
      )
      .onChange(of: selectedItem) { newItem in
        _Concurrency.Task {
          let data = try? await newItem?.loadTransferable(type: Data.self)
          uploadImageAction(data)
        }
      }
      .allowsHitTesting(self.state)
    }
  }
}

//extension UploadADrawingView {
//  private struct SampleDrawings: View {
//    let store: MyStore
//
//    init(with store: MyStore) {
//      self.store = store
//    }
//
//    var body: some View {
//      VStack(spacing: 15) {
//        Description()
//        SampleImages()
//      }
//    }
//
//    typealias sample = ADUIKitAsset.SampleDrawing
//
//    @ViewBuilder
//    func Description() -> some View {
//      let leftTitle = "S A M P L E"
//      let rightTitle = "D R A W I N G S"
//      let description = "Feel free to try the demo by clicking on one of the following example images."
//
//      VStack(alignment: .leading, spacing: 15) {
//        HStack(spacing: 15) {
//          Text(leftTitle)
//            .font(.system(.title3, weight: .semibold))
//          Text(rightTitle)
//            .font(.system(.title3, weight: .semibold))
//        }
//        Text(description)
//      }
//    }
//
//    @ViewBuilder
//    func SampleImages() -> some View {
//      let example1: ADUIKitImages = sample.step1Example1
//      let example2: ADUIKitImages = sample.step1Example2
//      let example3: ADUIKitImages = sample.step1Example3
//      let example4: ADUIKitImages = sample.step1Example4
//
//      VStack(spacing: 20) {
//        HStack(spacing: 20) {
//          ImageCardButton(image: example1)
//          ImageCardButton(image: example2)
//        }
//        HStack(spacing: 20) {
//          ImageCardButton(image: example3)
//          ImageCardButton(image: example4)
//        }
//      }
//      .frame(height: 450)
//    }
//
//    @ViewBuilder
//    func ImageCardButton(image sample: ADUIKitImages) -> some View {
//      WithViewStore(store, observe: { $0 }) { viewStore in
//        Button {
//          viewStore.send(.uploadDrawing(sample.image.pngData()))
//        } label: {
//          sample.swiftUIImage
//            .resizable()
//            .mask {
//              RoundedRectangle(cornerRadius: 15)
//            }
//        }
//      }
//    }
//  }
//}

extension UploadADrawingView {
  @ViewBuilder
  func SampleDrawings(tapCardAction: @escaping (Data?) -> ()) -> some View {
    SampleDrawingsDescription()
    SampleImages(tapCardAction: tapCardAction)
  }
  
  @ViewBuilder
  func SampleDrawingsDescription() -> some View {
    let leftTitle = "S A M P L E"
    let rightTitle = "D R A W I N G S"
    let description = "Feel free to try the demo by clicking on one of the following example images."
    
    VStack(alignment: .leading, spacing: 15) {
      HStack(spacing: 15) {
        Text(leftTitle)
          .font(.system(.title3, weight: .semibold))
        Text(rightTitle)
          .font(.system(.title3, weight: .semibold))
      }
      Text(description)
    }
  }
  
  struct SampleImages: View {
    let tapCardAction: (Data?) -> ()
    
    typealias sample = ADUIKitAsset.SampleDrawing
    let example1: ADUIKitImages = sample.step1Example1
    let example2: ADUIKitImages = sample.step1Example2
    let example3: ADUIKitImages = sample.step1Example3
    let example4: ADUIKitImages = sample.step1Example4
    
    var body: some View {
      VStack(spacing: 20) {
        HStack(spacing: 20) {
          ImageCardButton(image: example1)
          ImageCardButton(image: example2)
        }
        HStack(spacing: 20) {
          ImageCardButton(image: example3)
          ImageCardButton(image: example4)
        }
      }
      .frame(height: 450)
    }
    
    @ViewBuilder
    func ImageCardButton(image sample: ADUIKitImages) -> some View {
      Button {
        tapCardAction(sample.image.pngData())
      } label: {
        sample.swiftUIImage
          .resizable()
          .mask {
            RoundedRectangle(cornerRadius: 15)
          }
      }
    }
  }
}

// MARK: - Previews
struct UploadADrawingView_Previews: PreviewProvider {
  static var previews: some View {
    //    UploadADrawingView()
    MakeADView()
  }
}

//
//  ShareView.swift
//  AD_UI
//
//  Created by minii on 2023/08/24.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct ShareView: View {
  let gifData: Data
  
  var body: some View {
    ShareUIViewControllerRepresentable(gifData: gifData)
  }
}

struct ShareUIViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIActivityViewController
  
  let gifData: Data
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let uiActivityController = UIActivityViewController(
      activityItems: [gifData],
      applicationActivities: nil)
    
    return uiActivityController
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    
  }
}

// MARK: - Previews_ShareView

struct Previews_ShareView: View {
  @State var isShowShareView = false
  
  var body: some View {
    VStack {
      Button("ShowShareView") {
        self.isShowShareView.toggle()
      }
    }
    .sheet(isPresented: $isShowShareView) {
      ShareView(gifData: Data())
        .presentationDetents([.medium, .large])
    }
  }
}

struct ShareView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ShareView()
  }
}

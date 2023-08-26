//
//  ShareView.swift
//  AD_UI
//
//  Created by minii on 2023/08/24.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct ShareView: View {
  let gifURL: URL
  
  var body: some View {
    ShareUIViewControllerRepresentable(gifURL: gifURL)
  }
}

struct ShareUIViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIActivityViewController
  
  let gifURL: URL
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let vc = UIActivityViewController(
      activityItems: [gifURL],
      applicationActivities: nil
    )
    
    return vc
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    
  }
}

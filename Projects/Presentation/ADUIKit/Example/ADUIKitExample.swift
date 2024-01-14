//
//  ADUIKitExample.swift
//  ADUIKitExample
//
//  Created by minii on 2023/10/17.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

@main
struct ADUIKitExample: App {
  var body: some Scene {
    WindowGroup {
      Preview_ADUIKitExample()
    }
  }
}

struct Preview_ADUIKitExample: View {
  var body: some View {
    VStack {
      Text("ADUIKitExample")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .addBackground()
  }
}

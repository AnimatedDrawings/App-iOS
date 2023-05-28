//
//  UploadADrawing.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_UI
import AD_Utils

struct UploadADrawing: ADFeature {
  let ui = UploadADrawingView()
  
  var body: some View {
    ui.main(uploadAction: {})
  }
}

struct UploadADrawing_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawing()
  }
}

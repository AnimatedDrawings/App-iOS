//
//  GIFView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public class GIFPlayerView: UIView {
  private let imageView = UIImageView()
  
  public convenience init(gifName: String) {
    self.init()
    setGifName(gifName: gifName)
  }
  
  public convenience init(gifData: Data) {
    self.init()
    setGifData(gifData: gifData)
  }
  
  func setGifName(gifName: String) {
    let gif = UIImage.gif(asset: gifName)
    imageView.image = gif
    imageView.contentMode = .scaleAspectFit
    self.addSubview(imageView)
  }
  
  func setGifData(gifData: Data) {
    let gif = UIImage.gif(data: gifData)
    imageView.image = gif
    imageView.contentMode = .scaleAspectFit
    self.addSubview(imageView)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = bounds
  }
}

public struct GIFViewName: UIViewRepresentable {
  public typealias UIViewType = GIFPlayerView
  var gifName: String
  
  public init(_ gifName: String) {
    self.gifName = gifName
  }
  
  public func updateUIView(_ uiView: GIFPlayerView, context: Context) {
    uiView.setGifName(gifName: gifName)
  }
  
  public func makeUIView(context: Context) -> GIFPlayerView {
    return GIFPlayerView(gifName: gifName)
  }
}

public struct GIFViewData: UIViewRepresentable {
  public typealias UIViewType = GIFPlayerView
  var gifData: Data

  public init(_ gifData: Data) {
    self.gifData = gifData
  }

  public func updateUIView(_ uiView: GIFPlayerView, context: Context) {
    uiView.setGifData(gifData: gifData)
  }

  public func makeUIView(context: Context) -> GIFPlayerView {
    return GIFPlayerView(gifData: gifData)
  }
}

extension UIImageView {
  public func loadGif(name: String) {
    DispatchQueue.global().async {
      let image = UIImage.gif(name: name)
      DispatchQueue.main.async {
        self.image = image
      }
    }
  }
  
  public func loadGif(asset: String) {
    DispatchQueue.global().async {
      let image = UIImage.gif(asset: asset)
      DispatchQueue.main.async {
        self.image = image
      }
    }
  }
}

extension UIImage {
  
  public class func gif(data: Data) -> UIImage? {
    // Create source from data
    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
      print("SwiftGif: Source for the image does not exist")
      return nil
    }
    
    return UIImage.animatedImageWithSource(source)
  }
  
  public class func gif(url: String) -> UIImage? {
    // Validate URL
    guard let bundleURL = URL(string: url) else {
      print("SwiftGif: This image named \"\(url)\" does not exist")
      return nil
    }
    
    // Validate data
    guard let imageData = try? Data(contentsOf: bundleURL) else {
      print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
      return nil
    }
    
    return gif(data: imageData)
  }
  
  public class func gif(name: String) -> UIImage? {
    // Check for existance of gif
    guard let bundleURL = Bundle.main
      .url(forResource: name, withExtension: "gif") else {
      print("SwiftGif: This image named \"\(name)\" does not exist")
      return nil
    }
    
    // Validate data
    guard let imageData = try? Data(contentsOf: bundleURL) else {
      print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
      return nil
    }
    
    return gif(data: imageData)
  }
  
  public class func gif(asset: String) -> UIImage? {
    guard let dataAsset = NSDataAsset(name: asset, bundle: ADUtilsResources.bundle) else {
      print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
      return nil
    }
    
    return gif(data: dataAsset.data)
  }
  
  internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
    var delay = 0.1
    
    // Get dictionaries
    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
    defer {
      gifPropertiesPointer.deallocate()
    }
    let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
    if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
      return delay
    }
    
    let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
    
    // Get delay time
    var delayObject: AnyObject = unsafeBitCast(
      CFDictionaryGetValue(gifProperties,
                           Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
      to: AnyObject.self)
    if delayObject.doubleValue == 0 {
      delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                       Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
    }
    
    if let delayObject = delayObject as? Double, delayObject > 0 {
      delay = delayObject
    } else {
      delay = 0.1 // Make sure they're not too fast
    }
    
    return delay
  }
  
  internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
    var lhs = lhs
    var rhs = rhs
    // Check if one of them is nil
    if rhs == nil || lhs == nil {
      if rhs != nil {
        return rhs!
      } else if lhs != nil {
        return lhs!
      } else {
        return 0
      }
    }
    
    // Swap for modulo
    if lhs! < rhs! {
      let ctp = lhs
      lhs = rhs
      rhs = ctp
    }
    
    // Get greatest common divisor
    var rest: Int
    while true {
      rest = lhs! % rhs!
      
      if rest == 0 {
        return rhs! // Found it
      } else {
        lhs = rhs
        rhs = rest
      }
    }
  }
  
  internal class func gcdForArray(_ array: [Int]) -> Int {
    if array.isEmpty {
      return 1
    }
    
    var gcd = array[0]
    
    for val in array {
      gcd = UIImage.gcdForPair(val, gcd)
    }
    
    return gcd
  }
  
  internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
    let count = CGImageSourceGetCount(source)
    var images = [CGImage]()
    var delays = [Int]()
    
    // Fill arrays
    for index in 0..<count {
      // Add image
      if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
        images.append(image)
      }
      
      // At it's delay in cs
      let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                      source: source)
      delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
    }
    
    // Calculate full duration
    let duration: Int = {
      var sum = 0
      
      for val: Int in delays {
        sum += val
      }
      
      return sum
    }()
    
    // Get frames
    let gcd = gcdForArray(delays)
    var frames = [UIImage]()
    
    var frame: UIImage
    var frameCount: Int
    for index in 0..<count {
      frame = UIImage(cgImage: images[Int(index)])
      frameCount = Int(delays[Int(index)] / gcd)
      
      for _ in 0..<frameCount {
        frames.append(frame)
      }
    }
    
    // Heyhey
    let animation = UIImage.animatedImage(with: frames,
                                          duration: Double(duration) / 1000.0)
    
    return animation
  }
}
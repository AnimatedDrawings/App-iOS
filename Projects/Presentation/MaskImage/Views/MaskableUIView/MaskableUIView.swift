//
//  _MaskableUIView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/09.
//

import UIKit
import MaskImageFeatures

class MaskableUIView: UIView {
  // MARK: - Private Property
  private let croppedImageView: UIImageView = {
    let uiImageView = UIImageView()
    uiImageView.contentMode = .scaleToFill
    return uiImageView
  }()
  
  let initMaskImage: UIImage
  
  private var renderer: UIGraphicsImageRenderer?
  private var maskImage: UIImage? = nil
  private var maskLayer = CALayer()
  private var shapeLayer = CAShapeLayer()
  private var panGestureRecognizer = TouchDownPanGestureRecognizer()
  
  typealias CacheContent = (CAShapeLayer, UIImage?)
  private var cache: [CacheContent] = []
  
  // MARK: - Public Property
  var curDrawingState: DrawingToolState
  var curCircleRadius: CGFloat
  var maskedImage: UIImage? {
    guard let renderer = renderer else { return nil}
    let result = renderer.image {
      context in
      return self.croppedImageView.layer.render(in: context.cgContext)
    }
    return result
  }
  
  // MARK: - initializer
  init(
    myFrame: CGRect,
    croppedImage: UIImage,
    initMaskImage: UIImage,
    curDrawingState: DrawingToolState,
    curCircleRadius: CGFloat
  ) {
    self.croppedImageView.image = croppedImage
    self.initMaskImage = initMaskImage
    self.curDrawingState = curDrawingState
    self.curCircleRadius = curCircleRadius
    super.init(frame: CGRect(origin: .zero, size: myFrame.size))
    addMaskGesture()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addMaskGesture() {
    panGestureRecognizer.addTarget(self, action: #selector(gestureRecognizerUpdate))
    self.addGestureRecognizer(panGestureRecognizer)
  }
  
  private func setupLayout() {
    self.croppedImageView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(croppedImageView)
    
    croppedImageView.layer.masksToBounds = true
    croppedImageView.layer.mask = maskLayer
    croppedImageView.layer.superlayer?.addSublayer(shapeLayer)
  }
}

extension MaskableUIView {
  func updateBounds(myFrame: CGRect) {
    let myBounds = CGRect(origin: .zero, size: myFrame.size)
    
    guard self.frame != myBounds else {
      return
    }
    
    self.frame = myBounds
    self.croppedImageView.frame = self.bounds
    maskLayer.frame = self.layer.bounds
    shapeLayer.frame = self.layer.bounds
    shapeLayer.fillColor = UIColor.clear.cgColor
    
    renderer = UIGraphicsImageRenderer(size: self.bounds.size)
    guard let renderer = renderer else {
      return
    }
    let image = renderer.image { context in
      initMaskImage.draw(in: self.bounds)
    }
    maskImage = image
    maskLayer.contents = maskImage?.cgImage
  }
}

extension MaskableUIView {
  @IBAction func gestureRecognizerUpdate(_ sender: UIGestureRecognizer) {
    let cgPoint = sender.location(in: self)
    if sender.state == .began {
      addToCache()
    }
    if sender.state != .ended {
      drawCircleAtPoint(cgPoint: cgPoint)
    } else {
      self.shapeLayer.path = nil
    }
  }
  
  private func drawCircleAtPoint(cgPoint: CGPoint) {
    guard let renderer = renderer else {
      return
    }
    let image = renderer.image { context in
      if let maskImage = maskImage {
        maskImage.draw(in: self.bounds)
        let rect = CGRect(origin: cgPoint, size: .zero)
          .insetBy(dx: -curCircleRadius/2, dy: -curCircleRadius/2)
        let color = UIColor.black.cgColor
        context.cgContext.setFillColor(color)
        let blendMode: CGBlendMode
        let alpha: CGFloat
        
        if curDrawingState == .erase {
          blendMode = .sourceIn
          alpha = 0
        } else {
          blendMode = .normal
          alpha = 1
        }
        
        let circlePath = UIBezierPath(ovalIn: rect)
        circlePath.fill(with: blendMode, alpha: alpha)
        shapeLayer.path = circlePath.cgPath
      }
    }
    
    maskImage = image
    maskLayer.contents = maskImage?.cgImage
  }
}

// Undo, cache Method
extension MaskableUIView {
  func undo() {
    guard let tmpCache = self.cache.popLast() else {
      return
    }
    let tmpShapeLayer = tmpCache.0
    let tmpMaskImage = tmpCache.1
    
    self.shapeLayer = tmpShapeLayer
    self.maskImage = tmpMaskImage
    self.maskLayer.contents = tmpMaskImage?.cgImage
  }
  
  func addToCache() {
    guard let tmpCGImage = self.maskImage?.cgImage else {
      return
    }
    let tmpMaskImage = UIImage(cgImage: tmpCGImage)
    let tmpShapeLayer = CAShapeLayer(layer: self.shapeLayer)
    
    let element: CacheContent = (tmpShapeLayer, tmpMaskImage)
    self.cache.append(element)
  }
}

// Reset, trash method
extension MaskableUIView {
  func reset() {
    self.cache = []
    
    shapeLayer.fillColor = UIColor.clear.cgColor
    guard let renderer = renderer else {
      return
    }
    let image = renderer.image { context in
      initMaskImage.draw(in: self.bounds)
    }
//    let image = renderer.image { (ctx) in
//      UIColor.black.setFill()
//      ctx.fill(self.bounds, blendMode: .normal)
//    }
    maskImage = image
    maskLayer.contents = maskImage?.cgImage
  }
}

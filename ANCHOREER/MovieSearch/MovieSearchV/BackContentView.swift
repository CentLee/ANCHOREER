//
//  BackContentView.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

class BackContentView: UIView { //카드뷰
  @IBInspectable var cornerRadius: CGFloat = 8
  @IBInspectable var shadowcolor: UIColor? = UIColor.black
  @IBInspectable let shadowOffSetWidth : Int = 0
  @IBInspectable let shadowOffSetHeight : Int = 1
  @IBInspectable var shadowopacity: Float = 0.2
  
  override func layoutSubviews() {
    layer.cornerRadius = cornerRadius
    layer.shadowColor = shadowcolor?.cgColor
    layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    layer.shadowPath = shadowPath.cgPath
    layer.shadowOpacity = shadowopacity
  }
}

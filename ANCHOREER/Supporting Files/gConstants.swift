//
//  File.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

var screenWidth: CGFloat = UIScreen.main.bounds.width
var screenHeight: CGFloat = UIScreen.main.bounds.height

public func iPrint(_ objects:Any... , filename:String = #file,_ line:Int = #line, _ funcname:String = #function){ //debuging Print
  #if DEBUG
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "HH:mm:ss:SSS"
  let file = URL(string:filename)?.lastPathComponent.components(separatedBy: ".").first ?? ""
  print("💦info 🦋\(dateFormatter.string(from:Date())) 🌞\(file) 🍎line:\(line) 🌹\(funcname)🔥",terminator:"")
  for object in objects{
    print(object, terminator:"")
  }
  print("\n")
  #endif
}


extension UIImageView {
  func URLString(urlString: String) {
    guard urlString != "" else {
      self.image = UIImage(named: "movieEmpty")
      return
    }
    let url = String(urlString.split(separator: "|")[0]).trimmingCharacters(in: .whitespacesAndNewlines)
    guard let img_url = URL(string: url) else { return }
    
    let resource = ImageResource(downloadURL: img_url, cacheKey: url)
    kf.setImage(with: resource)
  }
}

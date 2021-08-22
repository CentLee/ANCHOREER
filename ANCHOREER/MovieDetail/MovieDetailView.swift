//
//  MovieDetailView.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation
import WebKit

class MovieDetailView: UIView {
  
  lazy var movieSummaryView: MovieSummaryView = MovieSummaryView().then {
    $0.backgroundColor = .white
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  lazy var webView: WKWebView = WKWebView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray
  }
    
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    layoutSetup()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
  
  
}

extension MovieDetailView {
  private func layoutSetup() {
    [movieSummaryView, webView].forEach { self.addSubview($0) }
    
    constrain(movieSummaryView) {
      $0.top == $0.superview!.top
      $0.left == $0.superview!.left
      $0.right == $0.superview!.right
      $0.height == 100
    }
    
    constrain(webView, movieSummaryView) {
      $0.top == $1.bottom
      $0.left == $1.left
      $0.right == $1.right
      $0.bottom == $0.superview!.bottom
    }
  }
}

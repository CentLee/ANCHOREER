//
//  mMvieSummaryView.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

class MovieSummaryView: UIView { //영화 검색 및 결과 목록 화면

  lazy var movieImage: UIImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleToFill
  }
  
  lazy var movieTitle: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 15)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.lineBreakMode = .byTruncatingTail
  }
  lazy var movieDirector: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  lazy var movieActors: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.numberOfLines = 0
    $0.lineBreakMode = .byTruncatingTail
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  lazy var movieRating: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  lazy var movieFavorite: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "unFavorite"), for: .normal)
    $0.setImage(UIImage(named: "Favorite"), for: .selected)
    $0.isHighlighted = false
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  lazy var infoStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.spacing = 10
    $0.alignment = .leading
  }
  //
  
  var titleHeight: NSLayoutConstraint = NSLayoutConstraint()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    layoutSetup()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
}
extension MovieSummaryView {
  private func layoutSetup() { // layout
  
    [movieImage,movieFavorite, infoStack].forEach { self.addSubview($0) }
    [movieTitle, movieDirector, movieActors, movieRating].forEach {infoStack.addArrangedSubview($0)}
  
    constrain(movieImage) {
      $0.left == $0.superview!.left
      $0.top == $0.superview!.top
      $0.bottom == $0.superview!.bottom
      $0.height <= 100
      $0.width == 50
    }
    
    constrain(movieTitle) {
      titleHeight = ($0.height <= 30)
    }

    constrain(movieFavorite, movieImage) {
      $0.top == $1.top
      $0.width == 15
      $0.height == 15
      $0.right == $0.superview!.right
    }
    
    constrain(infoStack, movieImage, movieFavorite) {
      $0.top == $0.superview!.top
      $0.left == $1.right + 5
      $0.right == $2.left - 5
      $0.bottom <= $0.superview!.bottom
    }
  }
  
  func config(info: MovieData) {
    movieImage.URLString(urlString: info.image)
    movieTitle.text = info.movieTitle
    movieDirector.text = info.movieDirector
    movieActors.text = info.movieActor
    movieRating.text = info.movieRating
    movieFavorite.isSelected = info.favorite
  }
}

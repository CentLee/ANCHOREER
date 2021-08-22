//
//  MovieTableViewCell.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  static let cellIdentifier: String = String(describing: self)
  
  lazy var movieBackV: BackContentView = BackContentView().then {
    $0.layer.masksToBounds = false
    $0.backgroundColor = .white
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  lazy var movieSummaryView: MovieSummaryView = MovieSummaryView().then {
    $0.backgroundColor = .white
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  var viewModel: MovieFavoriteViewModel?
  var movieInfo: MovieData = MovieData()
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    layoutSetup()
    bind()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension MovieTableViewCell {
  private func layoutSetup() {
    
    contentView.addSubview(movieBackV)
    movieBackV.addSubview(movieSummaryView)
    
    constrain(contentView) {
      $0.edges == $0.superview!.edges
    }
    
    constrain(movieBackV) {
      $0.top    == $0.superview!.top + 5
      $0.left   == $0.superview!.left + 5
      $0.right  == $0.superview!.right - 5
      $0.bottom == $0.superview!.bottom - 5
    }
    
    constrain(movieSummaryView, movieBackV) {
      $0.edges == $1.edges
    }
    
    
  }
  
  func config(info: MovieData) { // Data Configuration
    movieSummaryView.config(info: info)
    
    movieInfo = info
  }
  
  private func bind() {
    movieSummaryView.movieFavorite.rx.tap.asDriver()
      .drive(onNext: { [weak self] in
        guard let self = self else {return}
        iPrint(self.movieInfo.favorite)
        //self.movieSummaryView.movieFavorite.isSelected = !(self.movieSummaryView.movieFavorite.isSelected)
        self.movieInfo.favorite = !self.movieInfo.favorite
        self.viewModel?.input.movieFavorited(onFavorite: self.movieInfo.favorite, movie: self.movieInfo)
      }).disposed(by: disposeBag)
  }
  
  override func prepareForReuse() {
    viewModel = nil
  }
}

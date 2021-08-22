//
//  MovieDetailViewController.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import UIKit

class MovieDetailViewController: UIViewController {
  
  
  var viewModel: MovieFavoriteViewModel?
  var movieInfo: MovieData?
  var favoriteList: [MovieData] = []
  
  lazy var movieDetailView: MovieDetailView = MovieDetailView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutSetup { [weak self] in
      self?.config()
    }
    bind()
    // Do any additional setup after loading the view.
  }
  
  deinit {
    viewModel = nil
  }
}
extension MovieDetailViewController {
  private func layoutSetup(onCompleted: @escaping (() -> Void)){
    view.addSubview(movieDetailView)
    view.backgroundColor = .white
    
    constrain(movieDetailView) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
    
    onCompleted()
  }
  private func config() {
    guard let movieData: MovieData = movieInfo, let urlString: String = movieInfo?.link, let url: URL = URL(string: urlString) else {return}
    movieDetailView.movieSummaryView.config(info: movieData)
    movieDetailView.webView.load(URLRequest(url: url))
    movieDetailView.movieSummaryView.titleHeight.constant = 0
    movieDetailView.movieSummaryView.movieFavorite.isSelected = movieData.favorite
  }
  
  private func bind() {
    guard let viewModel: MovieFavoriteViewModel = viewModel else {return}
    
    
    movieDetailView.movieSummaryView.movieFavorite.rx.tap.asDriver()
      .drive(onNext: { [weak self] in
        guard let self = self, let movie: MovieData = self.movieInfo else {return}
        movie.favorite = !movie.favorite
        if movie.favorite { //true
          viewModel.movieFavorited(onFavorite: movie.favorite, movie: movie)
        } else {
          viewModel.removeFavorite(movie: movie)
        }
        self.movieDetailView.movieSummaryView.movieFavorite.isSelected = !self.movieDetailView.movieSummaryView.movieFavorite.isSelected
      }).disposed(by: disposeBag)
  }
}

//
//  MovieSearchViewModel.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

protocol MovieSearchInput {
  func movieSearch(title: String, start: Int)
  //func movieFavorite
}

protocol MovieSearchOutPut {
  var movieList: PublishSubject<[MovieData]> {get set}
}

protocol MovieSearchViewModelType {
  var input: MovieSearchInput {get}
  var output: MovieSearchOutPut {get}
}

class MovieSearchViewModel: MovieSearchInput, MovieSearchOutPut, MovieSearchViewModelType {

  
  var movieList: PublishSubject<[MovieData]> = PublishSubject<[MovieData]>()
  var input: MovieSearchInput {return self}
  var output: MovieSearchOutPut {return self}
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  func movieSearch(title: String, start: Int) {
    MovieNetwork.SI.movieList(query: title, start: start)
      .subscribe(onNext: { [weak self] (list) in
        self?.movieList.onNext(list.items)
      }).disposed(by: disposeBag)
  }
}

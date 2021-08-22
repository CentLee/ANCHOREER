//
//  MovieDetailViewModel.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/20.
//

import Foundation


protocol MovieDetailViewModelInput {
  var movieDetailInfo: MovieData {get set} // 이전 뷰에서 넘어오는 데이터 받아서 저장
  var movieFavoriteList: [MovieData] {get set} // ""
  
  func movieFavorited(info: MovieData) //즐겨찾기 누름 따로 구현
}
protocol MovieDetailViewModelOutput {
  var onPresentView: PublishSubject<Void> {get set} //단순 뷰 시그널
  var onCompletedFavorite: PublishSubject<Void> {get set}
}

protocol MovieDetailViewModelType {
  var input: MovieDetailViewModelInput {get}
  var output: MovieDetailViewModelOutput {get}
}

class MovieDetailViewModel: MovieDetailViewModelType, MovieDetailViewModelInput, MovieDetailViewModelOutput {
  var input: MovieDetailViewModelInput {return self}
  var output: MovieDetailViewModelOutput {return self}
  var onPresentView: PublishSubject<Void> = PublishSubject<Void>()
  var onCompletedFavorite: PublishSubject<Void> = PublishSubject<Void>()
  
  var movieDetailInfo: MovieData = MovieData() {
    didSet { //셋팅 되면 데이터 바인딩
      onPresentView.onNext(())
    }
  }
  var movieFavoriteList: [MovieData] = [] {
    didSet { //셋팅되면 즐찾 영화인지 확인해야지?
      onCompletedFavorite.onNext(())
    }
  }
  
  
  func movieFavorited(info: MovieData) {
    
  }
}

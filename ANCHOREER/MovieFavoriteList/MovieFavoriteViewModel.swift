//
//  MovieFavoriteViewModel.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/20.
//

import Foundation

protocol MovieFavoriteViewModelInput {
  func movieFavorited(onFavorite: Bool, movie: MovieData)
  func removeFavorite(movie: MovieData)
  func compareFavoriteList(movies: [MovieData], onCompleted: @escaping (([MovieData]) -> Void))
}
protocol MovieFavoriteViewModelOutput {
  var favoriteList: BehaviorRelay<[MovieData]> {get set}
}
protocol MovieFavoriteViewModelType {
  var input: MovieFavoriteViewModelInput {get}
  var output: MovieFavoriteViewModelOutput {get}
}

class MovieFavoriteViewModel: MovieFavoriteViewModelType, MovieFavoriteViewModelInput, MovieFavoriteViewModelOutput { //즐겨찾기 전용 뷰모델 ( cell에 넘겨서 이벤트 관장하는 용도
  var input: MovieFavoriteViewModelInput {return self}
  var output: MovieFavoriteViewModelOutput {return self}

  
  var favoriteList: BehaviorRelay<[MovieData]> = BehaviorRelay<[MovieData]>(value: [])
  var tempFavoriteList: [MovieData] = []
  
}
extension MovieFavoriteViewModel {
  func movieFavorited(onFavorite: Bool, movie: MovieData) {
    if onFavorite { //true 등록
      self.favoriteList.accept(self.favoriteList.value + [movie])
    } else { //remove
      self.removeFavorite(movie: movie)
    }
    tempFavoriteList = self.favoriteList.value
  }
  
  func removeFavorite(movie: MovieData) {
    for (index, data) in self.favoriteList.value.enumerated() {
      if data.image == movie.image {
        if data.title == movie.title {
          tempFavoriteList.remove(at: index)
          self.favoriteList.accept(tempFavoriteList)
        }
      }
    }
  }
  
  func compareFavoriteList(movies: [MovieData], onCompleted: @escaping (([MovieData]) -> Void)) { //검색 때마다 데이터 비교하는 함수 즐찾표현
    if self.favoriteList.value.count == 0 {
      for data in movies {
        data.favorite = false
      }
    } else {
      for data in movies {
        for data1 in self.favoriteList.value {
          if data.image == data1.image {
            if data.title == data1.title {
              data.favorite = data1.favorite
            }
          }
        }
      }
    }
    onCompleted(movies)
  }
}

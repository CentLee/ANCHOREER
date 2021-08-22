//
//  MovieNetwork.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

class MovieNetwork {
  static let SI: MovieNetwork = MovieNetwork()
  
  var baseUrl: String = ""
  var httpHeaders: HTTPHeaders = [:]
  init() {
    baseHeaders()
  }
  
  private func baseHeaders() {
    if let infoDic : [String : Any] = Bundle.main.infoDictionary {
      if let id: String = infoDic["Client-Id"] as? String,
        let secret: String = infoDic["Client-Secret"] as? String,
        let url: String = infoDic["SearchApiBaseUrl"] as? String {
        httpHeaders["X-Naver-Client-Id"] = id
        httpHeaders["X-Naver-Client-Secret"] = secret
        baseUrl = url
      }
    }
  }
  
  func movieList(query: String, start: Int) -> Observable<MovieList> {
    let str: String = self.baseUrl + "query=\(query)&display=20&start=\(start)"
    return Observable<MovieList>.create { observer in
      guard let encodingStr: String = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else
      {
        return Disposables.create()
      }
      guard let url: URL = URL(string: encodingStr) else
      {
        return Disposables.create()
      }
      
      AF.request(url, method: .get, headers: self.httpHeaders).responseJSON { (response) in
        switch response.result {
        case .success(_):
          iPrint(response.value)
          guard let json = response.value as? [String : Any] else { return }
          guard let data: MovieList = Mapper<MovieList>().map(JSON: json) else { return }
          observer.onNext(data)
          observer.onCompleted()
        case .failure(_):
          break
        }
      }
      return Disposables.create()
    }
  }
}

class MovieList: Mappable { //영화 검색 리스트
  var start: Int = 0
  var items: [MovieData] = []
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    start  <- map["start"]
    items  <- map["items"]
  }
}

class MovieData: Mappable {
  var title: String = ""
  var link: String = ""
  var image: String = ""
  var rating: String = ""
  var actor: String = ""
  var director: String = ""
  var favorite: Bool = false
  
  var movieTitle: String {
    return title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
  }
  var movieDirector: String {
    return "감독: " + director.replacingOccurrences(of: "|", with: " ")
  }
  var movieActor: String {
    return "출연: " + actor.replacingOccurrences(of: "|", with: " ")
  }
  var movieRating: String {
    return "평점: " + rating
  }

  required init?(map: Map) { }
  
  init() {
    self.actor = ""
    self.director = ""
    self.link = ""
    self.image = ""
    self.rating = ""
    self.title = ""
  }
  func mapping(map: Map) {
    title      <- map["title"]
    link       <- map["link"]
    image      <- map["image"]
    rating <- map["userRating"]
    actor      <- map["actor"]
    director   <- map["director"]
  }
}

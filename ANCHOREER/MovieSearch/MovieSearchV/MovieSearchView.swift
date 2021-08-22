//
//  MovieSearchView.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

class MovieSearchView: UIView { //영화 검색 및 결과 목록 화면
  //searchBar
  lazy var searchPanelView: UIView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1.5
  }
  lazy var searchField: UITextField = UITextField().then {
    $0.borderStyle = .none
    $0.backgroundColor = .clear
    $0.placeholder = "영화 이름을 검색해주세요"
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 15)
  }
  //searchBar
  
  //Main View
  lazy var movieListTable: UITableView = UITableView().then {
    $0.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 100
    $0.separatorStyle = .none
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    layoutSetup()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
}
extension MovieSearchView {
  private func layoutSetup() { // layout
    [searchPanelView, movieListTable].forEach { self.addSubview($0) }
    searchPanelView.addSubview(searchField)
    
    constrain(searchPanelView) {
      $0.height == 30
      $0.left   == $0.superview!.left + 10
      $0.right  == $0.superview!.right - 10
      $0.top    == $0.superview!.top + 20
    }
    
    constrain(movieListTable, searchPanelView) {
      $0.left == $1.left
      $0.right == $1.right
      $0.top == $1.bottom + 10
      $0.bottom == $0.superview!.bottom
    }
    
    constrain(searchField, searchPanelView) {
      $0.left == $1.left + 10
      $0.right == $1.right - 20
      $0.top == $1.top
      $0.bottom == $1.bottom
    }

  }

}

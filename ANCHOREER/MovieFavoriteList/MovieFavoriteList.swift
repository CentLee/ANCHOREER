//
//  MovieFavoriteList.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import Foundation

class MovieFavoriteList: UIView {
  lazy var movieListTable: UITableView = UITableView().then {
    $0.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 100
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    layoutSetup()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init() error")
  }
}

extension MovieFavoriteList {
  private func layoutSetup() {
    self.addSubview(movieListTable)
    
    constrain(movieListTable) {
      $0.edges == $0.superview!.edges
    }
  }
}

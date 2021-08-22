//
//  MovieFavoriteListViewController.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import UIKit

class MovieFavoriteListViewController: UIViewController {
  lazy var movieListTable: UITableView = UITableView().then {
    $0.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 100
    $0.separatorStyle = .none
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  var favoriteViewModel: MovieFavoriteViewModel?
  private let disposeBag: DisposeBag = DisposeBag()
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.topItem?.title = "즐겨찾기 목록"
    //navigationController?.navigationBar.isHidden = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutSetup {
      self.bind()
    }
    // Do any additional setup after loading the view.
  }
  
  deinit {
    favoriteViewModel = nil
  }
  
  
}
extension MovieFavoriteListViewController {
  private func layoutSetup(onCompleted: @escaping (() -> Void)) {
    view.addSubview(movieListTable)
    view.backgroundColor = .white
    
    constrain(movieListTable) {
      $0.edges == $0.superview!.safeAreaLayoutGuide.edges
    }
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeView))
    
    onCompleted()
  }
  
  private func bind() {
    movieListTable.dataSource = nil
      
    favoriteViewModel?.output.favoriteList.asDriver()
      .drive(movieListTable.rx.items(cellIdentifier: MovieTableViewCell.cellIdentifier, cellType: MovieTableViewCell.self)) { (row, movie, cell) in
        cell.config(info: movie)
        cell.viewModel = self.favoriteViewModel
        cell.tag = row
      }.disposed(by: disposeBag)
    
    movieListTable.rx.itemSelected.asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let self = self, let cell: MovieTableViewCell = self.movieListTable.cellForRow(at: indexPath) as? MovieTableViewCell else {return}
        let vc: MovieDetailViewController = MovieDetailViewController()
        vc.viewModel = self.favoriteViewModel
        vc.movieInfo = self.favoriteViewModel?.favoriteList.value[indexPath.row]
        vc.title = self.favoriteViewModel?.favoriteList.value[indexPath.row].movieTitle
        cell.isSelected = false
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
  @objc private func closeView() {
    self.navigationController?.dismiss(animated: true, completion: nil)
    favoriteViewModel = nil
  }
}

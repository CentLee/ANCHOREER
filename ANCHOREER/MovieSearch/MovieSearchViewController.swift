//
//  MovieSearchViewController.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import UIKit

class MovieSearchViewController: UIViewController{
  lazy var navigationTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
    $0.text = "네이버 영화 검색"
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 20)
  }
  lazy var navigationFavoriteButton: UIButton = UIButton().then {
    $0.setTitle("즐겨찾기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 10
  }
  
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
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let viewModel: MovieSearchViewModel = MovieSearchViewModel()
  private let favoriteViewModel: MovieFavoriteViewModel = MovieFavoriteViewModel()
  private var movieListSubject: PublishSubject<[MovieData]> = PublishSubject()
  private var movieList: [MovieData] = []
  private var movieFavoriteList: [MovieData] = []
  private var currentSearchKey: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutSetup()
    bind()
  }
}
extension MovieSearchViewController {
  private func layoutSetup() {
    
    [searchPanelView, movieListTable].forEach { self.view.addSubview($0) }
    searchPanelView.addSubview(searchField)
    
    constrain(searchPanelView, self.view) {
      $0.height == 30
      $0.left   == $1.safeAreaLayoutGuide.left + 10
      $0.right  == $1.safeAreaLayoutGuide.right - 10
      $0.top    == $1.safeAreaLayoutGuide.top + 20
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
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitle)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationFavoriteButton)
    navigationController?.navigationBar.backgroundColor = .white
    self.view.backgroundColor = .white
  }
  
  private func bind() {
    movieListTable.dataSource = nil
    
    searchField.rx.text.filter{$0 != ""}.distinctUntilChanged()
      .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: { [weak self] (str) in
        guard self != nil, let string: String = str else { return }
        self?.movieList.removeAll()
        self?.currentSearchKey = string
        self?.viewModel.input.movieSearch(title: string, start: 1) //값이 존재한다는 가정.
      }).disposed(by: disposeBag)
    
    viewModel.output.movieList.bind(to: movieListSubject).disposed(by: disposeBag)
    
    movieListSubject.map { [weak self] movieList -> [MovieData] in
      guard !movieList.isEmpty, let self = self else { return [] }
      self.movieList += movieList
      return self.movieList
    }.asDriver(onErrorJustReturn: [])
    .drive(movieListTable.rx.items(cellIdentifier: MovieTableViewCell.cellIdentifier, cellType: MovieTableViewCell.self)) { (row, movie, cell) in
      cell.config(info: movie)
      cell.viewModel = self.favoriteViewModel
      cell.tag = row
    }.disposed(by: disposeBag)
    
    movieListTable.rx.itemSelected.asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let self = self else {return}
        let vc: MovieDetailViewController = MovieDetailViewController()
        vc.viewModel = self.favoriteViewModel
        vc.movieInfo = self.movieList[indexPath.row]
        vc.favoriteList = self.movieFavoriteList
        vc.title = self.movieList[indexPath.row].movieTitle
        
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)

  
    navigationFavoriteButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] in
        guard let self = self else {return}
        let vc: MovieFavoriteListViewController = MovieFavoriteListViewController()
        vc.favoriteViewModel = self.favoriteViewModel
        vc.modalPresentationStyle = .overFullScreen
        vc.title = "즐겨찾기 목록"
        
        let navi = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navi, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    favoriteViewModel.output.favoriteList.asDriver()
      .drive(onNext: { _ in
        guard !(self.movieList.isEmpty) else {return}
        self.favoriteViewModel.input.compareFavoriteList(movies: self.movieList) { list in
          self.movieList = list
          self.movieListTable.reloadData()
        }
      }).disposed(by: disposeBag)
    
    movieListTable.rx.willDisplayCell.asDriver()
      .drive(onNext: { [weak self] cell in
        guard let self = self else {return}
        if cell.indexPath.row + 1 == self.movieList.count {
          self.viewModel.input.movieSearch(title: self.currentSearchKey, start: self.movieList.count+1)
        }
      }).disposed(by: disposeBag)
  }
}


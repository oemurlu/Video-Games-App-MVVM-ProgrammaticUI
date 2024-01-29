//
//  SearchViewController.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import UIKit

protocol SearchViewControllerInterface: AnyObject {
    func configureVC()
    func configureSearchBar()
    func configureCollectionView()
    func reloadCollectionView()
    func scrollToTop()
    func navigateToDetailScreen(gameDetails: GameResult, gameScreenshots: GameScreenshots)
    func startActivityIndicator()
    func stopActivityIndicator()
    func showTryAgainAlert(completion: @escaping () -> ())
}

final class SearchViewController: UIViewController {
    
    private var viewModel = SearchViewModel()
    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        print("SEARCH-VC INIT")
        super.init(nibName: nil, bundle: nil)
    }
        
    deinit {
        print("SEARCH-VC DEINIT")
    }
}

extension SearchViewController: SearchViewControllerInterface {
    func configureVC() {
        view.backgroundColor = UIColor(named: "background")
        self.title = "Search Games"
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar(frame: .zero)
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search games..."
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createSearchFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor(named: "black-white")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadCollectionView() {
        collectionView.reloadDataOnMainThread()
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            if !self.viewModel.games.isEmpty {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func navigateToDetailScreen(gameDetails: GameResult, gameScreenshots: GameScreenshots) {
        DispatchQueue.main.async {
            let detailScreen = DetailViewController(gameDetails: gameDetails, gameScreenshots: gameScreenshots)
            self.navigationController?.pushViewController(detailScreen, animated: true)
        }
    }
    
    func startActivityIndicator() {
        ActivityIndicatorHelper.shared.start()
    }
    
    func stopActivityIndicator() {
        ActivityIndicatorHelper.shared.stop()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseID, for: indexPath) as! SearchCell
        cell.setCell(game: viewModel.games[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gameId = viewModel.games[indexPath.item]._id
        viewModel.getDetail(id: gameId)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY >= contentHeight - (3 * height) {
            viewModel.searchGames(name: viewModel.searchText)
        }
    }
    
    func showTryAgainAlert(completion: @escaping () -> ()) {
        MakeAlert.shared.alertMessageWithHandler(vc: self) {
            completion()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

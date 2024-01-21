//
//  HomeViewController.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject {
    func configureVC()
    func configureCollectionViewCell()
    func reloadCollectionView()
}

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var collectionView: UICollectionView!
    private let padding: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension HomeViewController: HomeViewControllerInterface {
    func configureVC() {
        view.backgroundColor = .systemBackground
        self.title = "Popular Games"
    }
    
    func configureCollectionViewCell() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHomeFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadCollectionView() {
        collectionView.reloadDataOnMainThread()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseID, for: indexPath) as! GameCell
        cell.setCell(game: viewModel.games[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY >= contentHeight - (3 * height) {
            viewModel.getGames()
        }
    }
}

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
    func showPopOverFilter()
    func scrollToTop()
    func navigateToDetailScreen(gameDetails: GameResult, gameScreenshots: GameScreenshots)
    func startActivityIndicator()
    func stopActivityIndicator()
}

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var collectionView: UICollectionView!
    private let padding: CGFloat = 16
    private var rightBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        print("HOME-VC INIT")
    }
    
        
    deinit {
        print("HOME-VC DEINIT")
    }
}

extension HomeViewController: HomeViewControllerInterface {
    func configureVC() {
        view.backgroundColor = .systemBackground
        self.title = "Popular Games"
        
        rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(rightBarButton_TUI))
        rightBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func rightBarButton_TUI() {
        viewModel.showPopOverFilter()
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
    
    func showPopOverFilter() {
        let popVC = FilterPopOverViewController()
        let deviceWidth = CGFloat.deviceWidth
        let size = CGSize(width: deviceWidth / 2.6, height: deviceWidth / 2.6)
        popVC.delegate = self
        popVC.preferredContentSize = size
        popVC.modalPresentationStyle = .popover
        
        if let pres = popVC.presentationController {
            pres.delegate = self
        }
        
        present(popVC, animated: true)
        
        if let pop = popVC.popoverPresentationController {
            pop.barButtonItem = self.rightBarButtonItem
            pop.permittedArrowDirections = .up
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseID, for: indexPath) as! GameCell
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
            viewModel.getGames(filter: viewModel.chosenFilter!)
        }
    }
}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension HomeViewController: FilterPopOverDelegate {
    func filterCellDidSelect(filterBy: FilterBy) {        
        viewModel.filterSelected(filter: filterBy)
    }
}
    

//
//  DetailViewModel.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import Foundation

protocol DetailViewModelInterface {
    var view: DetailViewControllerInterface? { get set }
    func viewDidLoad()
    func handleGameScreenshots(games: GameScreenshots)
    func updateCurrentPageIndex(_ index: Int)
    func addGameToFavorites()
    func removeGameFromFavorites()
    func checkIfGameIsFavorite()
}

final class DetailViewModel {
    weak var view: DetailViewControllerInterface?
    var gameScreenshots: [ScreenShotResults] = []
    var gameDetails: GameResult
    var currentPageIndex: Int = 0 {
        didSet {
            view?.updatePageControl(currentPageIndex: currentPageIndex)
        }
    }
    
    private let favoriteManager = FavoritesManager.shared
    
    
    init(gameDetails: GameResult, gameScreenshots: GameScreenshots) {
        print("DETAIL-VM INIT")
        self.gameDetails = gameDetails
        handleGameScreenshots(games: gameScreenshots)
    }
    
    deinit {
        print("DETAIL-VM DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DetailViewModel: DetailViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
        view?.configurePageControl()
        view?.configureNameLabel()
        view?.configureFavoriteButton()
        view?.configureReleaseLabel()
        view?.configurePlaytimeContainerView()
        view?.configureRatingView()
        view?.configureMetascoreView()
        view?.configureRatingStackView()
        view?.configureOverviewTextView()
    }
    
    func handleGameScreenshots(games: GameScreenshots) {
        if let games = games.results {
            gameScreenshots = games
        }
    }
    
    func updateCurrentPageIndex(_ index: Int) {
        currentPageIndex = index
    }
    
    func addGameToFavorites() {
        guard let gameId = gameDetails.id else { return }
        favoriteManager.addFavorite(gameId: gameId)
    }
    
    func removeGameFromFavorites() {
        guard let gameId = gameDetails.id else { return }
        favoriteManager.removeFavorite(gameId: gameId)
    }
    
    func checkIfGameIsFavorite() {
        guard let gameId = gameDetails.id else { return }
        let isFavorite = favoriteManager.isFavorite(gameId: gameId)
    }
}

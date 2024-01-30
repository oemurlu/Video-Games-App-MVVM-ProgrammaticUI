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
    func viewWillAppear()
    func handleGameScreenshots(games: GameScreenshots)
    func updateCurrentPageIndex(_ index: Int)
    func addGameToFavorites(completion: @escaping () -> Void)
    func removeGameFromFavorites(completion: @escaping () -> Void)
    func checkIfGameIsFavorite()
    func favoriteButtonTapped()
}

final class DetailViewModel {
    weak var view: DetailViewControllerInterface?
    private let favoriteManager = FavoritesManager.shared
    var gameScreenshots: [ScreenShotResults] = []
    var gameDetails: GameResult
    var currentPageIndex: Int = 0 {
        didSet {
            view?.updatePageControl(currentPageIndex: currentPageIndex)
        }
    }
    var isFavorite: Bool = false
    
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
        view?.stopActivityIndicator()
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
    
    func viewWillAppear() {
        checkIfGameIsFavorite()
    }
    
    func handleGameScreenshots(games: GameScreenshots) {
        if let games = games.results {
            gameScreenshots = games
        }
    }
    
    func updateCurrentPageIndex(_ index: Int) {
        currentPageIndex = index
    }
    
    func addGameToFavorites(completion: @escaping () -> Void) {
        guard let gameId = gameDetails.id else { return }
        favoriteManager.addFavorite(gameId: gameId) { [weak self] in
            guard let self = self else { return }
            self.isFavorite = true
            completion()
        }
    }
    func removeGameFromFavorites(completion: @escaping () -> Void) {
        guard let gameId = gameDetails.id else { return }
        guard let gameToRemoveId = favoriteManager.favoriteGames.first(where: { $0 == gameId }) else { return }
        favoriteManager.removeFavorite(gameId: gameToRemoveId) { [weak self] in
            guard let self = self else { return }
            checkIfGameIsFavorite()
            completion()
            }
    }
    
    func checkIfGameIsFavorite() {
        guard let gameId = gameDetails.id else { return }
        favoriteManager.isFavorite(gameId: gameId) { [weak self] isFavorite in
            guard let self = self else { return }
            self.view?.updateFavoriteButton(isFavorited: isFavorite)
            self.isFavorite = isFavorite
        }
    }
    
    func favoriteButtonTapped() {
        if isFavorite {
            removeGameFromFavorites { [weak self] in
                guard let self = self else { return }
                self.view?.updateFavoriteButton(isFavorited: self.isFavorite)
            }
        } else {
            addGameToFavorites { [weak self] in
                guard let self = self else { return }
                self.view?.updateFavoriteButton(isFavorited: self.isFavorite)
            }
        }
    }
    
}

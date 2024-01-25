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
}

final class DetailViewModel {
    weak var view: DetailViewControllerInterface?
    var gameScreenshots: [ScreenShotResults] = []
    var gameDetails: GameResult
    var screenshotCount: Int = 0
    
    init(gameDetails: GameResult, gameScreenshots: GameScreenshots) {
        self.gameDetails = gameDetails
        handleGameScreenshots(games: gameScreenshots)
    }
}

extension DetailViewModel: DetailViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
        view?.configureNameLabel()
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
            screenshotCount = gameScreenshots.count
        }
    }
}

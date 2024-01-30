//
//  FavoritesViewModel.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import Foundation

protocol FavoritesViewModelInterface {
    var view: FavoritesViewControllerInterface? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func loadFavorites()
    func refreshFavorites()
    func deleteFromFavorites(indexPath: IndexPath)
    func showTryAgainAlert()
    func getDetail(id: Int)
}

final class FavoritesViewModel {
    weak var view: FavoritesViewControllerInterface?
    private let service = GameService()
    private let favoritesManager = FavoritesManager.shared
    var gameDetails: [GameResult] = []
    
    init() {
        print("FAVORITE-VM INIT")
    }
    
    deinit {
        print("FAVORITE-VM DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoritesViewModel: FavoritesViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureTableView()
    }
    
    func viewWillAppear() {
        view?.startActivityIndicator()
        refreshFavorites()
        //        FavoritesManager.shared.writeSql()
    }
    
    func loadFavorites() {
        self.gameDetails.removeAll()
        let group = DispatchGroup()
        var isErrorOccured = false
        var tempGameDetails = [Int: GameResult]()

        for favoriteGame in favoritesManager.favoriteGames {
            group.enter()
            service.downloadGameDetails(id: favoriteGame) { returnedGameResult in
                group.leave()
                if let gameResult = returnedGameResult {
                    tempGameDetails[favoriteGame] = gameResult
                } else {
                    isErrorOccured = true
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if isErrorOccured {
                self.view?.stopActivityIndicator()
                self.showTryAgainAlert()
                return
            }
            // gameDetails arrayini favoriteGames arrayi ile ayni sirada doldur
            self.gameDetails = self.favoritesManager.favoriteGames.compactMap { tempGameDetails[$0] }
            self.view?.reloadTableViewOnMain()
            self.view?.stopActivityIndicator()
        }
    }

    func refreshFavorites() {
        favoritesManager.updateFavoriteGames()
        loadFavorites()
    }

    
    func deleteFromFavorites(indexPath: IndexPath) {
        guard indexPath.row < favoritesManager.favoriteGames.count else { return }
        let toBeDeletedGameId = favoritesManager.favoriteGames[indexPath.row]
        
        // Önce dizilerden sil
        favoritesManager.favoriteGames.remove(at: indexPath.row)
        if let indexInGameDetails = self.gameDetails.firstIndex(where: { $0.id == toBeDeletedGameId }) {
            self.gameDetails.remove(at: indexInGameDetails)
        }
        self.view?.deleteTableRowWithAnimation(indexPath: indexPath)

        // Sonra CoreData'dan sil
        favoritesManager.removeFavorite(gameId: toBeDeletedGameId) {
            // Burada ekstra bir işlem yapmanız gerekebilir.
        }
    }

    
    func showTryAgainAlert() {
        view?.showTryAgainAlert { [weak self] in
            guard let self = self else { return }
            self.refreshFavorites()
        }
    }
    
    func getDetail(id: Int) {
        view?.startActivityIndicator()
        service.downloadGameDetailsAndScreenshots(id: id) { [weak self] (returnedDetails, returnedScreenshots) in
            guard let self = self else { return }
            guard let details = returnedDetails, let screenshots = returnedScreenshots else {
                view?.stopActivityIndicator()
                return
            }
            
            self.view?.navigateToDetailScreen(gameDetails: details, gameScreenshots: screenshots)
        }
    }

}

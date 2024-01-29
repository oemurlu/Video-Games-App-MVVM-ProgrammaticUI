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
        
        for favoriteGame in favoritesManager.favoriteGames {
            group.enter()
            service.downloadGameDetails(id: favoriteGame.id) { [weak self] returnedGameResult in
                group.leave()
                guard let self = self else { return }
                if let returnedGameResult = returnedGameResult, !self.gameDetails.contains(where: { $0.id == returnedGameResult.id }) {
                    self.gameDetails.append(returnedGameResult)
                } else {
                    isErrorOccured = true
                }
            }
        }
        
        // This block is executed when all asynchronous operations are completed
        group.notify(queue: .main) {
            if isErrorOccured {
                self.view?.stopActivityIndicator()
                self.showTryAgainAlert()
            }
            self.gameDetails.sort { $0._id < $1._id }
            self.view?.reloadTableViewOnMain()
            self.view?.stopActivityIndicator()
        }
    }
    
    
    func refreshFavorites() {
        favoritesManager.getFavoriteGameIDs { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                favoritesManager.favoriteGames = data
                self.loadFavorites()
            case .failure(let error):
                print("refreshFavoritesError: \(error.localizedDescription)")
                view?.stopActivityIndicator()
                self.showTryAgainAlert()
            }
        }
    }
    
    func deleteFromFavorites(indexPath: IndexPath) {
        guard indexPath.row < FavoritesManager.shared.favoriteGames.count else { return }
        let toBeDeletedGame = FavoritesManager.shared.favoriteGames[indexPath.row]
        
        favoritesManager.removeFavorite(game: toBeDeletedGame) { [weak self] in
            guard let self = self else { return }
            
            favoritesManager.favoriteGames.remove(at: indexPath.row)
            
            if let indexInGameDetails = self.gameDetails.firstIndex(where: { $0.id == toBeDeletedGame.id }) {
                self.gameDetails.remove(at: indexInGameDetails)
            }
            
            self.view?.deleteTableRowWithAnimation(indexPath: indexPath)
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

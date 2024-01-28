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
        refreshFavorites()
//        FavoritesManager.shared.writeSql()
    }
    
    func loadFavorites() {
        self.gameDetails.removeAll()
        let group = DispatchGroup()

        for favoriteGame in favoritesManager.favoriteGames {
            group.enter()
            service.downloadGameDetails(id: favoriteGame.id) { [weak self] returnedGameResult in
                group.leave()
                guard let self = self else { return }
                if let returnedGameResult = returnedGameResult, !self.gameDetails.contains(where: { $0.id == returnedGameResult.id }) {
                    self.gameDetails.append(returnedGameResult)
                }
            }
        }

        group.notify(queue: .main) { // Tüm asenkron işlemler tamamlandığında bu blok çalışır
            self.gameDetails.sort { $0._id < $1._id }
            self.view?.reloadTableViewOnMain()
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
            
            self.view?.reloadTableViewOnMain()
        }
    }
}

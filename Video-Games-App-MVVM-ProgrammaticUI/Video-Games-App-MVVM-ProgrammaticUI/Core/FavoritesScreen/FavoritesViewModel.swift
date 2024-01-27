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
    func loadFavorites()
    func refreshFavorites()
}

final class FavoritesViewModel {
    weak var view: FavoritesViewControllerInterface?
    private let service = GameService()
    private var favoriteIds: [Int] = [] {
        didSet {
            if oldValue != favoriteIds {
                loadFavorites()
            }
        }
    }
    
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
    
    func loadFavorites() {
        favoriteIds = FavoritesManager.shared.getFavoriteGameIDs()
        for id in favoriteIds {
            service.downloadGameDetailsAndScreenshots(id: id) { (details, screenshots) in
                // Gelen verileri kullanarak arayüzü güncelle
            }
        }
    }
    
    func refreshFavorites() {
            let newFavoriteIds = FavoritesManager.shared.getFavoriteGameIDs()
            if newFavoriteIds != favoriteIds {
                favoriteIds = newFavoriteIds
            }
        }
}

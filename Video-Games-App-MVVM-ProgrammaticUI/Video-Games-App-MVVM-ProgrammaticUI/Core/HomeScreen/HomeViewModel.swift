//
//  HomeViewModel.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import Foundation

protocol HomeViewModelInterface {
    var view: HomeViewControllerInterface? { get set }
    func viewDidLoad()
    func getGames()
}

final class HomeViewModel {
    weak var view: HomeViewControllerInterface?
    private let service = GameService()
    var games: [GameResult] = []
    private var page: Int = 1
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionViewCell()
        getGames()
    }
    
    func getGames() {
        service.downloadGames(page: page) { [weak self] returnedGames in
            guard let self = self else { return }
            guard let returnedGames = returnedGames else { return }
            self.games.append(contentsOf: returnedGames)
            self.page += 1
            view?.reloadCollectionView()
        }
    }
}

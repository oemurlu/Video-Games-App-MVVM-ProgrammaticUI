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
    func getGames(filter: FilterBy)
    func showPopOverFilter()
    func filterSelected(filter: FilterBy)
    func getDetail(id: Int)
}

final class HomeViewModel {
    weak var view: HomeViewControllerInterface?
    private let service = GameService()
    var games: [GameResult] = []
    private var page: Int = 1
    var chosenFilter: FilterBy?
    private var canLoadMorePages = true
    
    init() {
        print("HOME-VM INIT")
    }
        
    deinit {
        print("HOME-VM DEINIT")
    }
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionViewCell()
        getGames(filter: .popular)
    }
    
    func getGames(filter: FilterBy) {
        
        guard canLoadMorePages else { return }
        
        if chosenFilter != filter {
            chosenFilter = filter
            games = []
            page = 1
            view?.reloadCollectionView()
        }
        
        service.downloadGames(filter: filter, page: page) { [weak self] gameResponse in
            guard let self = self else { return }
            guard let gameResponse = gameResponse else { return }
            
            DispatchQueue.main.async {
                if let games = gameResponse.results {
                    self.games.append(contentsOf: games)
                }
                
                if let _ = gameResponse.next {
                    self.page += 1
                    self.canLoadMorePages = true
                } else {
                    self.canLoadMorePages = false
                }
                
                self.view?.reloadCollectionView()
            }
        }
    }
    
    func showPopOverFilter() {
        view?.showPopOverFilter()
    }
    
    func filterSelected(filter: FilterBy) {
        if chosenFilter == filter {
            view?.scrollToTop()
        } else {
            self.canLoadMorePages = true
            getGames(filter: filter)
        }
    }
    
    func getDetail(id: Int) {
        service.downloadGameDetails(id: id) { [weak self] returnedDetail in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetailScreen(game: returnedDetail)
        }
    }
}

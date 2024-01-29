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
    func showTryAgainAlert(filter: FilterBy)
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
        view?.startActivityIndicator()
        if chosenFilter != filter {
            chosenFilter = filter
            games = []
            page = 1
            view?.reloadCollectionView()
        }
        
        service.downloadGames(filter: filter, page: page) { [weak self] gameResponse in
            guard let self = self else { return }
            guard let gameResponse = gameResponse else {
                self.view?.stopActivityIndicator()
                //TODO: show alert and ask try again for request
                self.showTryAgainAlert(filter: filter)
                print("qwe")
                return
            }
            
            DispatchQueue.main.async {
                self.view?.stopActivityIndicator()
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
    
    func showTryAgainAlert(filter: FilterBy) {
        print("show alert vm")
        view?.showTryAgainAlert { [weak self] in
            guard let self = self else { return }
            self.getGames(filter: filter)
        }
    }
}

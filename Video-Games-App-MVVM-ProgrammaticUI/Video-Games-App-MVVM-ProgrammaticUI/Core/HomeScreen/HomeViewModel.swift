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
    //    func filterGames(filter: FilterBy)
}

final class HomeViewModel {
    weak var view: HomeViewControllerInterface?
    private let service = GameService()
    var games: [GameResult] = []
    private var page: Int = 1
    var chosenFilter: FilterBy?
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionViewCell()
        getGames(filter: .popular)
    }
    
    func getGames(filter: FilterBy) {
        
        // Eğer filtre değiştiyse veya aynı filtreye tekrar basıldıysa
        if chosenFilter != filter || (chosenFilter == filter && filter != .popular) {
            chosenFilter = filter
            games = [] // Listeyi sıfırla
            page = 1   // Sayfa numarasını sıfırla
        }
        
        switch filter {
        case .popular:
            self.chosenFilter = .popular
            service.downloadGames(filter: .popular, page: page) { [weak self] returnedGames in
                guard let self = self else { return }
                guard let returnedGames = returnedGames else { return }
                self.games.append(contentsOf: returnedGames)
                //                self.page += 1
                if !returnedGames.isEmpty {
                    self.page += 1
                }
                view?.reloadCollectionView()
                print("popular yuklendi. popular count: \(self.games.count)")
            }
        case .feed:
            self.chosenFilter = .feed
            print("feed download")
            service.downloadGames(filter: .feed, page: 1) { [weak self] returnedGames in
                guard let self = self else { return }
                guard let returnedGames = returnedGames else { return }
                self.games.append(contentsOf: returnedGames)
                view?.reloadCollectionView()
                print("feed yuklendi. feed count: \(self.games.count)")
            }
        case .topRated:
            break
        }
    }
    
    func showPopOverFilter() {
        view?.showPopOverFilter()
    }
}

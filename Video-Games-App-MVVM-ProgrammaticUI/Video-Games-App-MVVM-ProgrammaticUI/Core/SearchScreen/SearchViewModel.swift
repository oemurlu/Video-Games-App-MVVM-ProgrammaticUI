//
//  SearchViewModel.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import Foundation

protocol SearchViewModelInterface {
    var view: SearchViewControllerInterface? { get set }
    func viewDidLoad()
    func searchGames(name: String)
    func getDetail(id: Int)
}

final class SearchViewModel {
    
    weak var view: SearchViewControllerInterface?
    private let service = GameService()
    private var canLoadMorePages = true
    private var page: Int = 1
    var games: [GameResult] = []
    var searchTask: DispatchWorkItem?
    var searchText: String = "" {
        didSet {
            view?.scrollToTop()
            updateSearchResults(for: searchText)
        }
    }
    
    init() {
        print("SEARCHVM INIT")
    }
    
    deinit {
        print("SEARCHVM DEINIT")
    }
    
    private func updateSearchResults(for searchText: String) {
        searchTask?.cancel() // Eski görevi iptal et
        
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let formattedSearchText = self.formatSearchText(searchText)
            self.resetSearchResults()
            self.searchGames(name: formattedSearchText)
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
    
    private func formatSearchText(_ searchText: String) -> String {
        return searchText.replacingOccurrences(of: " ", with: "-")
    }
    
    private func resetSearchResults() {
        games = []
        page = 1
        canLoadMorePages = true
    }
}

extension SearchViewModel: SearchViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureSearchBar()
        view?.configureCollectionView()
        searchGames(name: "")
    }
    
    func searchGames(name: String) {
        guard canLoadMorePages else { return }
        
        service.searchGames(name: name, page: page) { [weak self] searchResponse in
            guard let self = self else { return }
            guard let searchResponse = searchResponse else { return }
            
            DispatchQueue.main.async {
                if let games = searchResponse.results {
                    self.games.append(contentsOf: games)
                }
                
                if searchResponse.next != nil {
                    self.page += 1
                    self.canLoadMorePages = true
                } else {
                    self.canLoadMorePages = false
                }
                self.view?.reloadCollectionView()
            }
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



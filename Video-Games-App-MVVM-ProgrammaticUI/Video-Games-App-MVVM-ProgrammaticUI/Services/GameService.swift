//
//  GameService.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import Foundation

final class GameService {
    
    func downloadGames(filter: FilterBy, page: Int, completion: @escaping (Game?) -> ()) {
        var urlString: String = ""
        switch filter {
        case .popular:
            urlString = APIURLs.games(page: page)
        case .feed:
            urlString = APIURLs.feed(page: page)
        case .topRated:
            urlString = APIURLs.topRated(page: page)
        }
        
        if urlString == "" { return }
        guard let url = URL(string: urlString) else { return }
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(self.decodeJSON(type: Game.self, data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func searchGames(name: String, page: Int, completion: @escaping (Game?) -> ()) {
        guard let url = URL(string: APIURLs.searchGames(name: name, page: page)) else { return }
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(self.decodeJSON(type: Game.self, data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func downloadGameDetailsAndScreenshots(id: Int, completion: @escaping (GameResult?, GameScreenshots?) -> ()) {
        let dispatchGroup = DispatchGroup()
        var gameDetails: GameResult?
        var gameScreenshots: GameScreenshots?
        
        dispatchGroup.enter()
        self.downloadGameDetails(id: id) { [weak self] details in
            guard let self = self else { return }
            gameDetails = details
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.downloadGameScreenshots(id: id) { [weak self] screenshots in
            guard let self = self else { return }
            gameScreenshots = screenshots
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(gameDetails, gameScreenshots)
        }
    }
    
    private func downloadGameScreenshots(id: Int, completion: @escaping (GameScreenshots?) -> ()) {
        guard let url = URL(string: APIURLs.gameScreenShots(id: id)) else { return }
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(self.decodeJSON(type: GameScreenshots.self, data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    private func downloadGameDetails(id: Int, completion: @escaping (GameResult?) -> ()) {
        guard let url = URL(string: APIURLs.gameDetail(id: id)) else { return }
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(self.decodeJSON(type: GameResult.self, data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, _ data: Data) -> T? {
        do {
            let decodedObj = try JSONDecoder().decode(T.self, from: data)
            return decodedObj
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func handleWithError(_ error: Error) {
        print(error.localizedDescription)
    }

}

//
//  GameService.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import Foundation

final class GameService {
    
    func downloadGames(page: Int, completion: @escaping ([GameResult]?) -> ()) {
        guard let url = URL(string: APIURLs.games(page: page)) else { return }
        print(url)
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    private func handleWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    private func handleWithData(_ data: Data) -> [GameResult]? {
        do {
            let movie = try JSONDecoder().decode(Game.self, from: data)
            return movie.results
        } catch {
            print(error)
            return nil
        }
    }
}

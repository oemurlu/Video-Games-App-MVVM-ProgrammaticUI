//
//  FavoritesManager.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import Foundation
import SwiftData

class FavoritesManager {
    static let shared = FavoritesManager()
    var container: ModelContainer?
    var context: ModelContext?
    var favoriteGames: [FavoriteGame] = []
    
    init() {
        do {
            container = try ModelContainer(for: FavoriteGame.self)
            if let container {
                context = ModelContext(container)
            }
            guard let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last else { return }
            print(appSupportDir)
        } catch {
            print("FavoritesManager init error: \(error.localizedDescription)")
        }
    }
    
    func addFavorite(gameId: Int, completion: @escaping () -> ()) {
        isFavorite(gameId: gameId) { isFavorited in
            if !isFavorited {
                // if the gameId is not in the database, then add it.
                if let context = self.context {
                    let idToBeSaved = FavoriteGame(id: gameId)
                    context.insert(idToBeSaved)
                    completion()
                }
            }
        }
    }
    
    func removeFavorite(game: FavoriteGame, completion: () -> ()) {
        if let context {
            context.delete(game)
            completion()
        }
    }
    
    func isFavorite(gameId: Int, completion: @escaping (Bool) -> ()) {
        getFavoriteGameIDs { result in
            switch result {
            case .success(let favoriteGames):
                let isFavorited = favoriteGames.contains(where: { $0.id == gameId })
                completion(isFavorited)
            case .failure(let error):
                print("Error checking if game is favorite: \(error)")
                completion(false)
            }
        }
    }
    
    func getFavoriteGameIDs(completion: @escaping (Result<[FavoriteGame], Error>) -> ()) {
        let descriptor = FetchDescriptor<FavoriteGame>(sortBy: [SortDescriptor<FavoriteGame>(\.id)])
        if let context {
            do {
                let data = try context.fetch(descriptor)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func printSqlLocation() {
        print(context?.sqliteCommand as Any)
    }
}


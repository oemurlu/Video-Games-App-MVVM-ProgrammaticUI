//
//  FavoritesManager.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import UIKit
import CoreData

class FavoritesManager {
    static let shared = FavoritesManager()
    var favoriteGames: [Int] = []
    
    init() {
        updateFavoriteGames()
    }
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func addFavorite(gameId: Int, completion: @escaping () -> ()) {
        isFavorite(gameId: gameId) { [weak self] isFavorited in
            guard let self = self else { return }
            if !isFavorited {
                // if the gameId is not in the database, then add it.
                let context = self.getContext()
                guard let entity = NSEntityDescription.entity(forEntityName: "Yapilacak", in: context) else { return }
                
                let newObj = NSManagedObject(entity: entity, insertInto: context)
                
                newObj.setValue(gameId, forKey: "id")
                newObj.setValue(Date(), forKey: "dateAdded")
                self.saveContext()
                self.updateFavoriteGames()
                completion()
            }
        }
    }
    
    func updateFavoriteGames() {
        if let fetchedGames = getFavoriteGameIDs() {
            favoriteGames = fetchedGames.map { Int($0.id) }
        }
    }
    
    func getFavoriteGameIDs() -> [Yapilacak]? {
        let fetchRequest: NSFetchRequest<Yapilacak> = Yapilacak.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        do {
            return try getContext().fetch(fetchRequest)
        } catch {
            print("getFavGameIds: \(error)")
        }
        return nil
    }
    
    func removeFavorite(gameId: Int, completion: @escaping () -> ()) {
        let context = getContext()
        if let fetchedGames = getFavoriteGameIDs() {
            for game in fetchedGames where game.id == gameId {
                context.delete(game)
            }
        }
        saveContext()
        updateFavoriteGames()
        completion()
    }
    
    func isFavorite(gameId: Int, completion: @escaping (Bool) -> ()) {
        completion(favoriteGames.contains(gameId))
        
    }
}


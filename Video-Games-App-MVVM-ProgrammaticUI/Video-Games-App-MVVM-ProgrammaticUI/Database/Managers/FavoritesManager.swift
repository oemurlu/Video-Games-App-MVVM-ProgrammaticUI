//
//  FavoritesManager.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private init() {}
    
    func addFavorite(gameId: Int) {
        // ID'yi veritabanına ekle
        print("addFav: \(gameId)")
    }
    
    func removeFavorite(gameId: Int) {
        // ID'yi veritabanından kaldır
        print("removeFav: \(gameId)")
    }
    
    func isFavorite(gameId: Int) -> Bool {
        // Oyunun favori olup olmadığını kontrol et
        print("isFav: \(gameId)")
        return false
    }
    
    func getFavoriteGameIDs() -> [Int] {
        // Tüm favori oyun ID'lerini döndür
        print("getFavGameIDs")
        return []
    }
}


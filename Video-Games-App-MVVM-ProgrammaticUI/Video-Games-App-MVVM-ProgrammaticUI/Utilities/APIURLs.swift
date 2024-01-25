//
//  APIURLs.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import Foundation

enum APIURLs {
    static func games(page: Int) -> String {
        "https://api.rawg.io/api/games?key=b434ff4979084154b0b27f39118e8d57&page_size=10&page=\(page)&platforms=18,1,7"
    }
    
    static func feed(page: Int) -> String {
        "https://rawg.io/api/collections/must-play/games?key=b434ff4979084154b0b27f39118e8d57"
    }
    
    static func topRated(page: Int) -> String {
        "https://api.rawg.io/api/games?key=b434ff4979084154b0b27f39118e8d57&ordering=-metacritic&page=\(page)&page_size=10&platforms=18,1,7&metacritic=91,100&dates=2018-01-01,2025-12-31"
    }
    
    static func searchGames(name: String, page: Int) -> String {
        "https://api.rawg.io/api/games?key=b434ff4979084154b0b27f39118e8d57&page_size=20&page=\(page)&platforms=18,1,7&search=\(name)"
    }
    
    static func gameDetail(id: Int) -> String {
        "https://api.rawg.io/api/games/\(id)?&key=b434ff4979084154b0b27f39118e8d57"
    }
    
    static func gameScreenShots(id: Int) -> String {
        "https://api.rawg.io/api/games/\(id)/screenshots?&key=b434ff4979084154b0b27f39118e8d57"
    }
}

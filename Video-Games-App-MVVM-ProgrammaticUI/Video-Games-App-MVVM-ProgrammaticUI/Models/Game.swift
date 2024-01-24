//
//  Game.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import Foundation

struct Game: Decodable {
    let next: String?
    let results: [GameResult]?
}

struct GameResult: Decodable {
    let slug: String?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case slug, name, released, rating, id
        case backgroundImage = "background_image"
    }
    
    var _slug: String {
        slug ?? "N/A"
    }
    
    var _name: String {
        name ?? "N/A"
    }
    
    var _released: String {
        released ?? "N/A"
    }
    
    var _backgroundImage: String {
        backgroundImage ?? "N/A"
    }
    
    var _rating: Double {
        rating ?? 0.0
    }
    
    var _id: Int {
        id ?? Int.min
    }
}

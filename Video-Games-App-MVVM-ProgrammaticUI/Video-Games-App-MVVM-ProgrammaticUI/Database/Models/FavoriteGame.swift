//
//  FavoriteGame.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import Foundation

struct FavoriteGame {
    let id: Int?
    
    var _id: Int {
        id ?? 0
    }
}

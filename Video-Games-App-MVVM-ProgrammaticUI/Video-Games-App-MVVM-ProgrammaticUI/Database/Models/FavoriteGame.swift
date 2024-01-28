//
//  FavoriteGame.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import Foundation
import SwiftData

@Model
class FavoriteGame {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

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
}

//
//  GameScreenshots.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 25.01.2024.
//

import Foundation

struct GameScreenshots: Decodable {
    let count: Int?
    let results: [ScreenShotResults]?
}

struct ScreenShotResults: Decodable {
    let image: String?
    
    var _image: String {
        image ?? "N/A"
    }
}

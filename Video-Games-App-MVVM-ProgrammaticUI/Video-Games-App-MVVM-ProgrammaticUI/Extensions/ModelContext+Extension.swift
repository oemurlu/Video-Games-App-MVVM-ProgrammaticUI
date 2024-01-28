//
//  ModelContext+Extension.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 28.01.2024.
//

import SwiftData

// show sql file path.
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3\"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}


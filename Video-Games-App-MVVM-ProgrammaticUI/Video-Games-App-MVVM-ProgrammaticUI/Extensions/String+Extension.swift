//
//  String+Extension.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 25.01.2024.
//

import Foundation

extension String {
    // html parser
    func htmlAttributedString(fontSize: CGFloat, hexColorString: String) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
        <head>
        <style>
        body {
        font-family: -apple-system;
        font-size: \(fontSize)px;
        color: \(hexColorString);
        text-align: justify;
        }
        </style>
        </head>
        <body>
        \(self)
        </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else { return nil }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
}

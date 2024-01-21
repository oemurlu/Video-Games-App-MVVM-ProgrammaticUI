//
//  UIHelper.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import UIKit

enum UIHelper {
    static func createHomeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let cellWidth = CGFloat.dWidth
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / 1.2)
        layout.minimumLineSpacing = 16
        
        return layout
    }
}



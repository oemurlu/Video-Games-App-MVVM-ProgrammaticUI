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
        
        let cellWidth = CGFloat.deviceWidth
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / 1.2)
        layout.minimumLineSpacing = 16
        
        return layout
    }
    
    static func createSearchFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 12
        let minimumSpacing: CGFloat = 12
        let availableWidth = CGFloat.deviceWidth - (padding * 2) - minimumSpacing
        let cellWidth = availableWidth / 2
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / 1.2)
        layout.minimumLineSpacing = minimumSpacing
        layout.minimumInteritemSpacing = minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        return layout
    }
}



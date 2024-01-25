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
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / 1.77)
        layout.minimumLineSpacing = minimumSpacing
        layout.minimumInteritemSpacing = minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        return layout
    }
    
    static func createDetailFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let cellWidth = CGFloat.deviceWidth
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / (16/9))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
    
    static func createContainerViewForDetailScreenStackView(withBorderColor borderColor: UIColor, cornerRadius: CGFloat) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = borderColor.cgColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        return view
        
    }
    
    static func createLabelForDetailScreenStackView(withText text: String, fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = .center
        return label
        
    }
}



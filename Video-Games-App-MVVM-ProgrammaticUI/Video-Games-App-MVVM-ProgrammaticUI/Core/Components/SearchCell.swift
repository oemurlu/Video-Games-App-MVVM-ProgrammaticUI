//
//  SearchCell.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import UIKit

final class SearchCell: UICollectionViewCell {
    static let reuseID = "GameCell"
    private var posterImageView: PosterImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configurePosterImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        posterImageView.cancelDownloading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(game: GameResult) {
        posterImageView.downloadImage(game: game)
    }
    
    private func configureCell() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        posterImageView.pinToEdgesOf(view: self)
    }
}

//
//  DetailCell.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 25.01.2024.
//

import UIKit

final class DetailCell: UICollectionViewCell {
    static let reuseID = "DetailCell"
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
    
    private func configureCell() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        posterImageView.pinToEdgesOf(view: self)
        posterImageView.backgroundColor = .green
    }
    
    func setCell(game: ScreenShotResults) {
        posterImageView.downloadDetailImage(game: game)
    }
}

//
//  GameCell.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import UIKit

final class GameCell: UICollectionViewCell {
    static let reuseID = "GameCell"
    private var posterImageView: PosterImageView!
    private var title: UILabel!
    private var releasedTime: UILabel!
    private var rating: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configurePosterImageView()
        configureTitle()
        configureReleaseTime()
        configureRating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        posterImageView.cancelDownloading()
    }
    
    private func configureCell() {
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor(named: "background-cell")
    }
    
    func setCell(game: GameResult) {
        DispatchQueue.main.async {
            self.title.text = game._name
            self.posterImageView.downloadImage(game: game)
            self.releasedTime.text = game._released
            self.rating.text = "⭐️ \(game._rating)"
        }
    }
    
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 1.77),
        ])
    }
    
    private func configureTitle() {
        title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 24, weight: .bold)
        title.textColor = .white
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            title.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16)
        ])
    }
    
    private func configureReleaseTime() {
        releasedTime = UILabel(frame: .zero)
        releasedTime.translatesAutoresizingMaskIntoConstraints = false
        releasedTime.font = .systemFont(ofSize: 20, weight: .bold)
        releasedTime.textColor = .secondaryLabel
        
        addSubview(releasedTime)
        
        NSLayoutConstraint.activate([
            releasedTime.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            releasedTime.leadingAnchor.constraint(equalTo: title.leadingAnchor)
        ])
    }
    
    private func configureRating() {
        rating = UILabel(frame: .zero)
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.font = .systemFont(ofSize: 20, weight: .bold)
        rating.textColor = .systemYellow
        
        addSubview(rating)
        
        NSLayoutConstraint.activate([
            rating.centerYAnchor.constraint(equalTo: releasedTime.centerYAnchor),
            rating.trailingAnchor.constraint(equalTo: title.trailingAnchor)
        ])
    }
}

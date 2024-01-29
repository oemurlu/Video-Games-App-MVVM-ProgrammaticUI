//
//  FavoriteCell.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let reuseID = "FavoriteCell"
    private var posterImageView: PosterImageView!
    private var subView: UIView!
    private var nameLabel: UILabel!
    private var releaseLabel: UILabel!
    private var ratingLabel: UILabel!
    
    private let padding: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subView = UIView()
        contentView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            subView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            subView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            subView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        configureCell()
        configureSubView()
        configurePosterImageView()
        configureNameLabel()
        configureReleaseLabel()
        configureRatingLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        posterImageView.cancelDownloading()
    }
    
    func setCell(game: GameResult) {
        posterImageView.downloadImage(game: game)
        nameLabel.text = game._name
        releaseLabel.text = game._released
        ratingLabel.text = "⭐️ \(game._rating) / 5"
        
    }
    
    private func configureSubView() {
        subView.layer.cornerRadius = 8
        subView.clipsToBounds = true
        subView.backgroundColor = .systemGray5
    }
    
    private func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        subView.addSubview(posterImageView)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            posterImageView.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            posterImageView.topAnchor.constraint(equalTo: subView.topAnchor, constant: padding),
            posterImageView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -padding),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: padding)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel = UILabel(frame: .zero)
        subView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureReleaseLabel() {
        releaseLabel = UILabel(frame: .zero)
        subView.addSubview(releaseLabel)
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        releaseLabel.font = .systemFont(ofSize: 16, weight: .medium)
        releaseLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            releaseLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding / 2),
            releaseLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            releaseLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func configureRatingLabel() {
        ratingLabel = UILabel(frame: .zero)
        subView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ratingLabel.font = .systemFont(ofSize: 20, weight: .bold)
        ratingLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: releaseLabel.bottomAnchor, constant: padding / 2),
            ratingLabel.leadingAnchor.constraint(equalTo: releaseLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: releaseLabel.trailingAnchor)
        ])
    }
}

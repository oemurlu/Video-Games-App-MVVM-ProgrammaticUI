//
//  PosterImageView.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 21.01.2024.
//

import UIKit

final class PosterImageView: UIImageView {
    private var dataTask: URLSessionDataTask?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupActivityIndicator()
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func downloadImage(game: GameResult) {
        activityIndicator.startAnimating()
        guard let url = URL(string: game._backgroundImage) else { return }
        dataTask = NetworkManager.shared.download(url: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.image = UIImage(data: data)
                }
            case .failure(_):
                break
            }
        })
    }
    
    func downloadDetailImage(game: ScreenShotResults) {
        activityIndicator.startAnimating()
        guard let url = URL(string: game._image) else { return }
        dataTask = NetworkManager.shared.download(url: url, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.image = UIImage(data: data)
                }
            case .failure(_):
                break
            }
        })
    }
    
    func cancelDownloading() {
        dataTask?.cancel()
        dataTask = nil
    }
}

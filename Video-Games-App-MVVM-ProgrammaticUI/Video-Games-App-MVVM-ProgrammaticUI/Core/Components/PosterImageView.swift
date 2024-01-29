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
                    if let image = UIImage(data: data) {
                        let resizedImage = self.resizeImage(image: image, targetSize: CGSize(width: 960, height: 540))
                        //Swift With Vincent
                        let compressedImage = self.compressImage(image: resizedImage)
                        Task {
                            self.image = await compressedImage?.byPreparingForDisplay()
                        }
                    }
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
                    if let image = UIImage(data: data) {
                        let resizedImage = self.resizeImage(image: image, targetSize: CGSize(width: 960, height: 540))
                        //Swift With Vincent
                        let compressedImage = self.compressImage(image: resizedImage)
                        Task {
                            self.image = await compressedImage?.byPreparingForDisplay()
                        }
                    }
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
    
    private func compressImage(image: UIImage) -> UIImage? {
        guard let compressedData = image.jpegData(compressionQuality: 0.5) else { return nil }
        return UIImage(data: compressedData)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}

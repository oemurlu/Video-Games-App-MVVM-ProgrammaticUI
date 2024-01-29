//
//  ActivityIndicatorHelper.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 29.01.2024.
//

import UIKit

class ActivityIndicatorHelper {
    static let shared = ActivityIndicatorHelper()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        return indicatorView
    }()
    
    private let keyWindow: UIWindow?
    private var blurView: UIVisualEffectView?
    
    private init() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                keyWindow = windowScene.windows.first
            } else {
                keyWindow = nil
            }
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
    }
    
    func start() {
        DispatchQueue.main.async {
            self.darkenBackground(of: self.keyWindow)
            self.setupIndicator()
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func stop() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.removeDarkenBackground(from: self.keyWindow)
        }
    }
    
    private func setupIndicator() {
        guard let keyWindow = keyWindow else { return }
        activityIndicatorView.color = .white
        activityIndicatorView.center = keyWindow.center
        keyWindow.addSubview(activityIndicatorView)
        keyWindow.bringSubviewToFront(activityIndicatorView)
    }
    
    private func darkenBackground(of view: UIView?) {
        guard let view = view else { return }
        
        let darkOverlay = UIView(frame: view.bounds)
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        darkOverlay.tag = 1001
        darkOverlay.alpha = 0
        view.addSubview(darkOverlay)
        
        UIView.animate(withDuration: 0.3) {
            darkOverlay.alpha = 1
        }
    }
    
    private func removeDarkenBackground(from view: UIView?) {
        if let darkOverlay = view?.viewWithTag(1001) {
            UIView.animate(withDuration: 0.3, animations: {
                darkOverlay.alpha = 0
            }, completion: { _ in
                darkOverlay.removeFromSuperview()
            })
        }
    }
    
}

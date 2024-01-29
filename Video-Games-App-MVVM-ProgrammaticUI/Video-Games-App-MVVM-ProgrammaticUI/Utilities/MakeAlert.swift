//
//  MakeAlert.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 29.01.2024.
//

import UIKit

struct MakeAlert {
    
    static let shared = MakeAlert()
    
    private init() {}
    
    func alertMessageWithHandler(vc: UIViewController, retryHandler: @escaping () -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Connection Error!", message: "Please check your connection!", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Try Again", style: .default) { _ in
                retryHandler()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

            alert.addAction(retryAction)
            alert.addAction(cancelAction)
            
            vc.present(alert, animated: true)
        }
    }
}

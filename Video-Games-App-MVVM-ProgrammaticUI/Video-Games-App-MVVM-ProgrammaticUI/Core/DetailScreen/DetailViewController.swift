//
//  DetailViewController.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import UIKit

protocol DetailViewControllerInterface: AnyObject {
    func configureVC()
}

class DetailViewController: UIViewController {

    private let viewModel = DetailViewModel()
    private let game: GameScreenshots
    
    init(game: GameScreenshots) {
        print("DETAIL-VC INIT")
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("DETAIL-VC DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }

}

extension DetailViewController: DetailViewControllerInterface {
    func configureVC() {
        view.backgroundColor = .magenta
    }
}

//
//  FavoritesViewModel.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import Foundation

protocol FavoritesViewModelInterface {
    var view: FavoritesViewControllerInterface? { get set }
    func viewDidLoad()
}

final class FavoritesViewModel {
    weak var view: FavoritesViewControllerInterface?
    
    init() {
        print("FAVORITE-VM INIT")
    }
    
    deinit {
        print("FAVORITE-VM DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoritesViewModel: FavoritesViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureTableView()
    }
}

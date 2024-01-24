//
//  SearchViewModel.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import Foundation

protocol SearchViewModelInterface {
    var view: SearchViewControllerInterface? { get set }
    func viewDidLoad()
}

final class SearchViewModel {
    weak var view: SearchViewControllerInterface?
    
}

extension SearchViewModel: SearchViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureSearchBar()
        view?.configureCollectionView()
    }
}



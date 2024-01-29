//
//  FavoritesViewController.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 26.01.2024.
//

import UIKit

protocol FavoritesViewControllerInterface: AnyObject {
    func configureVC()
    func configureTableView()
    func reloadTableViewOnMain()
    func deleteTableRowWithAnimation(indexPath: IndexPath)
    func startActivityIndicator()
    func stopActivityIndicator()
}

class FavoritesViewController: UIViewController {
    
    private let viewModel = FavoritesViewModel()
    private var tableView: UITableView!

    init() {
        print("FAVORITE-VC INIT")
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("FAVORITE-VC DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }
}

extension FavoritesViewController: FavoritesViewControllerInterface {
    func configureVC() {
        view.backgroundColor = .systemBackground
        self.title = "Favorite Games"
    }
    
    func configureTableView() {
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.pinToEdgesOfSafeArea(view: view)
    }
    
    func reloadTableViewOnMain() {
        tableView.reloadDataOnMainThread()
    }
    
    func deleteTableRowWithAnimation(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func startActivityIndicator() {
        ActivityIndicatorHelper.shared.start()
    }
    
    func stopActivityIndicator() {
        ActivityIndicatorHelper.shared.stop()
    }

}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gameDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.setCell(game: viewModel.gameDetails[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat.deviceWidth / 2.3
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            self.viewModel.deleteFromFavorites(indexPath: indexPath)
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}

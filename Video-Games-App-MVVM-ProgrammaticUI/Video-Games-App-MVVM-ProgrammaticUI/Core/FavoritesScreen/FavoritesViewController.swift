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
}

class FavoritesViewController: UIViewController {
    
    private let viewModel = FavoritesViewModel()
    private var tableView: UITableView!
    let mockGameScreenshot = ScreenShotResults(image: "https://media.rawg.io/media/games/490/49016e06ae2103881ff6373248843069.jpg")
    let mockGameDetail = GameResult(slug: "", name: "Red Dead Redemption 2", released: "2018-05-31", backgroundImage: "https://media.rawg.io/media/games/511/5118aff5091cb3efec399c808f8c598f.jpg", rating: 4.8, id: 28, metacritic: 96, playtime: 20, description: "lorem ipsum dolor")

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
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.setCell(game: mockGameDetail)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked ip: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat.deviceWidth / 2.3
    }
}

//
//  FilterPopOverViewController.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 22.01.2024.
//

import UIKit

enum FilterBy {
    case popular
    case feed
    case topRated
}

protocol FilterPopOverDelegate: AnyObject {
    func filterCellDidSelect(filterBy: FilterBy)
}

protocol FilterPopOverInterface {
    func configureTableView()
}

class FilterPopOverViewController: UIViewController {
    
    weak var delegate: FilterPopOverDelegate?
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
}

extension FilterPopOverViewController: FilterPopOverInterface {
    func configureTableView() {
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseID)
        tableView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: .deviceWidth / 2)
        ])
    }
}

extension FilterPopOverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseID, for: indexPath) as! FilterCell
        
        var cellText = ""
        switch indexPath.row {
        case 0: cellText = "Popular"
        case 1: cellText = "Feed"
        case 2: cellText = "Latest"
        default: cellText = ""
        }
        
        cell.configureCell(text: cellText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        .deviceWidth / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            
            switch indexPath.row {
            case 0: self.delegate?.filterCellDidSelect(filterBy: .popular)
            case 1: self.delegate?.filterCellDidSelect(filterBy: .feed)
            case 2: self.delegate?.filterCellDidSelect(filterBy: .topRated)
            default: break;
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

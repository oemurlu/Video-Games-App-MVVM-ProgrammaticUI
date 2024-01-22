//
//  FilterCell.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 22.01.2024.
//

import UIKit

final class FilterCell: UITableViewCell {
    
    static let reuseID = "FilterCell"
    private var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awakeFromNib")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        print("setSelected")
    }
    
    func configureCell(text: String) {
        label = UILabel(frame: .zero)
        addSubview(label)
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

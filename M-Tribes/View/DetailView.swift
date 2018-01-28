//
//  DetailView.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/26/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import EasyPeasy

class DetailView: BaseView {
    
    // MARK: - Properties
    private lazy var downImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "down")
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailTableViewCell.self,
                           forCellReuseIdentifier: CellIdentifier.DetailCell.rawValue)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var details: [Detail] = [] {
        didSet {
            updateConstraints()
            tableView.reloadData()
        }
    }
    
    // MARK: - Initial Setup
    override func setup() {
        self.backgroundColor = .white
        self.addSubview(tableView)
        self.addSubview(downImageView)
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        tableView.rowHeight = frame.height/5
        downImageView.easy.layout(
            Top(0),
            Width(20),
            Height(20),
            CenterX(0).to(self, .centerX)
        )
        tableView.easy.layout(Edges())
    }
}

// MARK: - UITableView DataSouce
extension DetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.DetailCell.rawValue, for: indexPath) as! DetailTableViewCell
        if indexPath.row == 0 {
            cell.itemLabel.font = UIFont.helveticaLight18
            cell.itemLabel.textColor = .black
        }
        cell.updateConstraints()
        cell.itemImageView.image = details[indexPath.row].image
        cell.itemLabel.text = details[indexPath.row].label
        return cell
    }
}

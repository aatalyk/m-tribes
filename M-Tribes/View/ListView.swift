//
//  ListView.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/25/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import EasyPeasy

class ListView: BaseView {
    
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CarTableViewCell.self,
                           forCellReuseIdentifier: CellIdentifier.CarCell.rawValue)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.addTarget(self,
                         action: #selector(close),
                         for: .touchUpInside)
        return button
    }()
    
    var cars: [Car] = [] {
        didSet {
            updateConstraints()
            tableView.reloadData()
        }
    }
    
    var myLocation: CLLocation? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Initial setup
    override func setup() {
        self.backgroundColor = .black
        self.addSubview(tableView)
        self.addSubview(closeButton)
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        tableView.rowHeight = frame.height*0.9/6
        
        tableView.easy.layout(
            Top(0),
            Left(0).to(self, .left),
            Width(frame.width),
            Height(frame.height*0.92)
        )
        
        closeButton.easy.layout(
            Top(frame.height*0.95-10),
            CenterX(0).to(tableView, .centerX),
            Width(20),
            Height(20)
        )
    }
    
    //MARK: - Helpers
    @objc private func close() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(NotificationName.HideListView.rawValue),
                                object: nil, userInfo: nil)
    }
    
    fileprivate func distanceBetweenCoordinates(fromCoordinate: Coordinate?) -> String {
        
        guard let location = myLocation else { return "~" }
        
        guard let coordinate = fromCoordinate else { return "~" }
        
        let distance = Int(location.distance(from: CLLocation(latitude: coordinate.latitude,
                                                              longitude: coordinate.longitude)))
        
        let distanceKm = String(distance/1000)
        
        return distanceKm
    }
}

//MARK: - UITableView Delegate
extension ListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = [UserInfo.Car.rawValue: cars[indexPath.row]]
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(NotificationName.HideListView.rawValue),
                                object: nil,
                                userInfo: userInfo)
    }
}

//MARK: - UITableView DataSource
extension ListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CarCell.rawValue, for: indexPath) as! CarTableViewCell
        cell.nameLabel.text = cars[indexPath.row].name
        cell.addressLabel.text = cars[indexPath.row].address
        cell.vinLabel.text = cars[indexPath.row].vin
        cell.distanceLabel.text = "\(distanceBetweenCoordinates(fromCoordinate: cars[indexPath.row].coordinate)) km"
        return cell
    }
}



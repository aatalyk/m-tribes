//
//  MapViewController.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import EasyPeasy

class MapViewController: BaseViewController {
    
    // MARK: - Properties
    private lazy var mapView: MapView = {
        let mapView = MapView()
        return mapView
    }()
    
    private lazy var listView: ListView = {
        let listView = ListView()
        return listView
    }()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(presentAlertController))
        return item
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "map"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(zoomOutCamera))
        return item
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView  = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.color = .gray
        indicatorView.startAnimating()
        indicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    let alertController = UIAlertController()
    var topBarHeight: CGFloat = 0.0
    var listViewHidden = true
    
    var cars: [Car] = [] {
        didSet {
            mapView.cars = cars
            listView.cars = cars
            updateViewConstraints()
        }
    }
    
    
    //MARK: - Initial Setup
    override func setup() {
        view.addSubview(mapView)
        view.addSubview(listView)
        view.addSubview(activityIndicatorView)
        updateViewConstraints()
        setupNavigationBar()
        setupAlertController()
        setupNotificationCenter()
        fetchCarsFromLocal()
        fetchCarsFromRemote()
    }
    
    private func setupNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(animateListView),
                                       name: NSNotification.Name(NotificationName.HideListView.rawValue),
                                       object: nil)
    }
    
    private func setupNavigationBar() {
        title = "M-Tribes"
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.setDefaults()
        navigationController?.view.addSubview(listView)
        topBarHeight = navigationController?.navigationBar.frame.height ?? 0
    }
    
    private func setupAlertController() {
        let cancelAlertAction = UIAlertAction(title: "Cancel",
                                              style: .cancel,
                                              handler: nil)
        cancelAlertAction.setValue(UIColor.red,
                                   forKey: "titleTextColor")
        let listAlertAction = UIAlertAction(title: "Show cars list",
                                            style: .default) { [weak self]
                                                (alert: UIAlertAction!) in
                                                guard let weakSelf = self else { return }
                                                weakSelf.listView.myLocation = weakSelf.mapView.mapView.myLocation
                                                weakSelf.animateListView()
        }
        let updateAlertAction = UIAlertAction(title: "Update cars",
                                              style: .default)
        { (alert: UIAlertAction!) in self.fetchCarsFromRemote() }
        
        alertController.addAction(cancelAlertAction)
        alertController.addAction(listAlertAction)
        alertController.addAction(updateAlertAction)
        alertController.title = nil
        alertController.message = nil
    }
    
    // MARK: - Helpers
    @objc private func animateListView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.listView.frame.origin.y = weakSelf.listViewHidden ? 0 : weakSelf.view.frame.height * 2
            weakSelf.listViewHidden = !weakSelf.listViewHidden
        }
    }
    
    @objc private func zoomOutCamera() {
        mapView.zoomOutCamera()
    }
    
    @objc private func presentAlertController() {
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Data fetching
    private func fetchCarsFromLocal() {
        activityIndicatorView.startAnimating()
        Car.fetchCarsFromLocalDataStore { (cars) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.update(cars: cars)
            }
        }
    }
    
    private func fetchCarsFromRemote() {
        activityIndicatorView.startAnimating()
        Car.fetchCarsFromRemoteDB { (cars) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.update(cars: cars)
            }
        }
    }
    
    private func update(cars: [Car]) {
        self.cars = cars
        activityIndicatorView.stopAnimating()
    }
    
    //MARK: - Set Constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        activityIndicatorView.center = CGPoint(x: view.frame.width/2,
                                               y: view.frame.height*0.4)
        
        mapView.easy.layout(
            Edges()
        )
        
        listView.easy.layout(
            Left(0),
            Top(view.frame.height * 2),
            Height(view.frame.height + topBarHeight + CGFloat.statusBarHeight),
            Width(view.frame.width)
        )
    }
    
}


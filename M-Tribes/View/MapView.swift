//
//  MapView.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import EasyPeasy

class MapView: BaseView {
    
    //MARK: - Properties
    var camera = GMSCameraPosition.camera(withLatitude: 53.59301,
                                          longitude: 10.07526,
                                          zoom: 14)
    
    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView.map(withFrame: CGRect.zero,
                                     camera: GMSCameraPosition.camera(withLatitude: 53.59301,
                                                                      longitude: 10.07526,
                                                                      zoom: 18))
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.addObserver(self,
                            forKeyPath: "selectedMarker",
                            options: [.new, .old],
                            context: nil)
        return mapView
    }()
    
    private lazy var detailView: DetailView = {
        let view = DetailView()
        view.layer.cornerRadius = 10
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(hideDetailedView)))
        return view
    }()
    
    fileprivate var clusterManager: GMUClusterManager!
    fileprivate var tappedMarker: GMSMarker?
    
    var markers: [POIItem] = []
    var cars: [Car] = [] {
        didSet {
            generateClusterItems()
            updateConstraints()
        }
    }
    var showInfoWindow = false
    
    //MARK: - Initial setup
    override func setup() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(hideDetailedView))
        mapView.addGestureRecognizer(tap)
        self.addSubview(mapView)
        self.addSubview(detailView)
        updateConstraints()
        setupClusters()
        setupNotificationCenter()
    }
    
    private func setupClusters() {
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [10, 20, 50, 100, 200])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView,
                                           algorithm: algorithm,
                                           renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    private func setupNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(showCar(_:)),
                                       name: NSNotification.Name(NotificationName.HideListView.rawValue),
                                       object: nil)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        detailView.easy.layout(
            Width(frame.width),
            Height(frame.height/3),
            Left(0),
            Top(frame.height)
        )
        
        mapView.easy.layout(
            Right(0),
            Left(0),
            Top(0),
            Bottom(0)
        )
    }
    
    //MARK: - MapView data
    fileprivate func generateClusterItems() {
        tappedMarker = nil
        mapView.clear()
        clusterManager.clearItems()
        markers.removeAll()
        mapView.selectedMarker = nil
        for car in cars {
            if let latitude = car.coordinate?.latitude,
                let longitude = car.coordinate?.longitude {
                
                let item = POIItem(position: CLLocationCoordinate2DMake(latitude, longitude),
                                   name: car.name)
                
                markers.append(item)
                clusterManager.add(item)
            }
        }
        clusterManager.cluster()
    }
    
    fileprivate func removeClusterItems(except poiItem: POIItem, marker: GMSMarker) {
        
        showInfoWindow = true
        
        mapView.clear()
        
        clusterManager.clearItems()
        clusterManager.add(poiItem)
        clusterManager.cluster()
        
        marker.map = mapView
        marker.userData = poiItem
        marker.title = poiItem.name
        tappedMarker = marker
    }
    
    //MARK: - Notifications
    // workaround "marker doesn't belong to map" error
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedMarker" {
            if showInfoWindow && change != nil {
                let object = (change as AnyObject)
                let markerObject = object.object(forKey: NSKeyValueChangeKey.oldKey)
                if let marker = markerObject as? GMSMarker {
                    marker.map = mapView
                    mapView.selectedMarker = marker
                    showInfoWindow = false
                }
            }
        }
    }
    
    //MARK: - Helper methods
    @objc private func showCar(_ notification: Notification) {
        generateClusterItems()
        guard let car = notification.userInfo?[UserInfo.Car.rawValue] as? Car else {
            return
        }
        if let latitude = car.coordinate?.latitude,
            let longitude = car.coordinate?.longitude {
            camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 25)
            mapView.animate(to: camera)
            
            let details = [
                Detail(image: #imageLiteral(resourceName: "car"), label: car.name),
                Detail(image: #imageLiteral(resourceName: "pin"), label: car.address),
                Detail(image: #imageLiteral(resourceName: "tag"), label: car.vin),
                Detail(image: #imageLiteral(resourceName: "fuel"), label: "\(car.fuel)"),
                Detail(image: #imageLiteral(resourceName: "engine"), label: car.engineType)
            ]
            detailView.details = details
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.detailView.frame.origin.y = weakSelf.frame.height*2/3
            }

        }
    }
    
    @objc private func hideDetailedView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.detailView.frame.origin.y = weakSelf.frame.height
        }
    }
    
    func zoomOutCamera() {
        mapView.animate(to: GMSCameraPosition.camera(withLatitude: camera.target.latitude,
                                                     longitude: camera.target.longitude,
                                                     zoom: 14))
        hideDetailedView()
    }
}

//MARK: - GMSMapView Delegate
extension MapView: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let poiItem = marker.userData as? POIItem else {
            return true
        }
        if let tappedMarker = tappedMarker {
            if tappedMarker.position.latitude == marker.position.latitude && tappedMarker.position.longitude == marker.position.longitude {
                generateClusterItems()
                showInfoWindow = false
                self.tappedMarker = nil
            }
        } else {
            removeClusterItems(except: poiItem, marker: marker)
        }
        return false
    }
}

//MARK: - GMUClusterManager Delegate
extension MapView: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager,
                        didTap cluster: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
}


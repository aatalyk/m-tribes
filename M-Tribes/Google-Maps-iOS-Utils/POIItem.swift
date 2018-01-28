//
//  POIItem.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import GoogleMaps
import UIKit

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}

//
//  Hints.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import Foundation

class Utils {
    static let googleMapsApiKey = "AIzaSyDSL9lziB_N96ZUAFNc-9w44NEj0LcKLMo"
    static let placeURLString = "http://data.m-tribes.com/locations.json"
}

enum NotificationName: String {
    case HideListView = "HideListView"
}

enum CellIdentifier: String {
    case CarCell = "CarCell"
    case DetailCell = "DetailCell"
}

enum UserInfo: String {
    case Car = "Car"
}

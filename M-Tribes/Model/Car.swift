//
//  Place.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import Realm

class Coordinate: Object {
    dynamic var longitude = 0.0
    dynamic var latitude = 0.0
    dynamic var degree = 0.0
}

class Car: Object {
    
    dynamic var address = ""
    dynamic var coordinate: Coordinate?
    dynamic var engineType = ""
    dynamic var fuel = 0.0
    dynamic var interior = ""
    dynamic var name = ""
    dynamic var vin = ""
    
    override class func primaryKey() -> String? {
        return "vin"
    }
    
    static func fetchCarsFromRemoteDB(completion: @escaping ([Car]) -> ()) {
        
        Alamofire.request(Utils.placeURLString).responseJSON { (response) in
            
            DispatchQueue.global(qos: .background).async {
                switch(response.result){
                case .success(_):
                    if let data = response.result.value as? [String : Any] {
                        
                        guard let placemarks = data["placemarks"] as? [[String : Any]] else {
                            print("Unable to get placemarks")
                            return
                        }
                        
                        var cars: [Car] = []
                        
                        for item in placemarks {
                            
                            let car = Car()
                            
                            if let address = item["address"] as? String  {
                                car.address = address
                            }
                            if let coordinates = item["coordinates"] as? [Double] {
                                if coordinates.count>2 {
                                    let coordinate = Coordinate()
                                    coordinate.longitude = coordinates[0]
                                    coordinate.latitude = coordinates[1]
                                    coordinate.degree = coordinates[2]
                                    car.coordinate = coordinate
                                }
                            }
                            if let engineType = item["engineType"] as? String {
                                car.engineType = engineType
                            }
                            if let fuel = item["fuel"] as? Double {
                                car.fuel = fuel
                            }
                            if let interior = item["interior"] as? String {
                                car.interior = interior
                            }
                            if let name = item["name"] as? String {
                                car.name = name
                            }
                            if let vin = item["vin"] as? String {
                                car.vin = vin
                            }
                            
                            car.saveToLocalStore()
                            
                            cars.append(car)
                        }
                        completion(cars)
                    }
                    break
                case .failure(_):
                    print(response.result.error ?? "API Error")
                    break
                }
            }
        }
    }
    
    func saveToLocalStore() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(Car.self,
                             value:
                    [self.address,
                     self.coordinate ?? Coordinate(),
                     self.engineType,
                     self.fuel,
                     self.interior,
                     self.name,
                     self.vin],
                             update: true)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    static func fetchCarsFromLocalDataStore(completion: @escaping ([Car]) -> ()) {
        do {
            var cars: [Car] = []
            let realm = try Realm()
            cars = realm.objects(Car.self).toArray(ofType: Car.self) as [Car]
            completion(cars)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}


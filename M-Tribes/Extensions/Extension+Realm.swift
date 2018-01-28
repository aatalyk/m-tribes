//
//  Extension+Results.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/28/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array: [T] = []
        for i in 0..<count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

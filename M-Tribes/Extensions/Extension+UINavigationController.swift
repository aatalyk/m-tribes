//
//  Extension+UINavigationController.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/28/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import Foundation

extension UINavigationController {
    func setDefaults() {
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}

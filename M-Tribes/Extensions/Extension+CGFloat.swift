//
//  Extension+CGFloat.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/28/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import Foundation

extension CGFloat {
    static let statusBarHeight: CGFloat = {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }()
}

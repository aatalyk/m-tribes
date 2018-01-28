//
//  BaseView.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

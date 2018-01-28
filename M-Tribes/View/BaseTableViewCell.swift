//
//  BaseTableViewCell.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/28/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    func setup() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

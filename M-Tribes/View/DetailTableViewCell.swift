//
//  DetailTableViewCell.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/28/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import EasyPeasy

class DetailTableViewCell: BaseTableViewCell {
    
    lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var itemLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.helveticaLight16
        label.numberOfLines = 0
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    override func setup() {
        self.addSubview(itemLabel)
        self.addSubview(itemImageView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        itemLabel.easy.layout(
            Width(frame.width*0.75),
            Height(frame.height),
            Top(0),
            CenterX(0).to(self, .centerX)
        )
        
        itemImageView.easy.layout(
            Width(20),
            Height(20),
            CenterY(0).to(itemLabel, .centerY),
            Right(10).to(itemLabel, .left)
        )
    }
}

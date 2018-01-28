//
//  CarTableViewCell.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/25/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import EasyPeasy

class CarTableViewCell: BaseTableViewCell {
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.helveticaLight18
        label.textColor = UIColor.mtBlueColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.helveticaLight18
        return label
    }()
    
    lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.helveticaLight14
        label.textColor = .lightGray
        return label
    }()
    
    lazy var vinLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.helveticaLight14
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right"), for: .normal)
        return button
    }()
    
    override func setup() {
        self.backgroundColor = .clear
        self.addSubview(distanceLabel)
        self.addSubview(nameLabel)
        self.addSubview(addressLabel)
        self.addSubview(vinLabel)
        self.addSubview(rightButton)
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        rightButton.easy.layout(
            Width(15),
            Height(15),
            CenterY(0).to(self),
            Right(20).to(self, .right)
        )
        
        distanceLabel.easy.layout(
            Width(frame.height*0.7),
            Height(frame.height*0.7),
            CenterY(0).to(self, .centerY),
            Left(10)
        )
        
        nameLabel.easy.layout(
            Top(10),
            Left(10).to(distanceLabel, .right),
            Right(10).to(rightButton, .left),
            Height(frame.height/3)
        )
        
        addressLabel.easy.layout(
            Top(0).to(nameLabel, .bottom),
            Left(10).to(distanceLabel, .right),
            Right(10).to(rightButton, .left),
            Height(frame.height/4)
        )
        
        vinLabel.easy.layout(
            Top(0).to(addressLabel, .bottom),
            Left(10).to(distanceLabel, .right),
            Right(10).to(rightButton, .left),
            Height(frame.height/4)
        )
    }
}

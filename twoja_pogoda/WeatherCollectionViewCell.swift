//
//  PogodaCollectionViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
        
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    /*
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    */
}

//
//  PogodaCollectionViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class PogodaCollectionViewCell: UICollectionViewCell {
        
    
    @IBOutlet weak var dataGodz: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var opis: UILabel!
    @IBOutlet weak var ciśnienie: UILabel!
    @IBOutlet weak var wilgotność: UILabel!
    @IBOutlet weak var zachmurzenie: UILabel!
    @IBOutlet weak var wiatr: UILabel!
    @IBOutlet weak var deszcz: UILabel!
    /*
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    */
}

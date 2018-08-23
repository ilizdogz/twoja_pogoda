//
//  MiejsceTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillLabels(place: String, temp: Double, rain: Double) {
        placeLabel.text = place
        tempLabel.text = "\(String(format: "%.2f", temp)) \(tempUnit.rawValue)"
        rainLabel.text = "\(String(format: "%.2f", rain)) mm"
    }
    
    func changeColors(colors: SavedColors) {
        tempLabel.textColor = colors.temp
        rainLabel.textColor = colors.rain
        if (Colors.isDark(colors.bg)) {
            placeLabel.textColor = UIColor.white
        } else {
            placeLabel.textColor = Colors.navCont
        }
    }

}

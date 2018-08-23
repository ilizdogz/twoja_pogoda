//
//  DzisiajTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 24.01.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColors() {
        todayLabel.textColor = savedColors.day
        descLabel.textColor = savedColors.desc
        tempLabel.textColor = savedColors.temp
        windLabel.textColor = savedColors.wind
        rainLabel.textColor = savedColors.rain
    }

}

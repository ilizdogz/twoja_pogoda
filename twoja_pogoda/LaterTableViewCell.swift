//
//  PozniejTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 24.01.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit

class LaterTableViewCell: UITableViewCell {

    @IBOutlet weak var nightLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayDescLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var nightDescLabel: UILabel!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var nightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColors() {
        dayView.backgroundColor = savedColors.bg
        nightView.backgroundColor = savedColors.bg
        dateLabel.textColor = savedColors.day
        dayDescLabel.textColor = savedColors.desc
        nightDescLabel.textColor = savedColors.desc
        dayTempLabel.textColor = savedColors.temp
        nightTempLabel.textColor = savedColors.temp
        dayLabel.textColor = savedColors.hour
        nightLabel.textColor = savedColors.hour
    }

}

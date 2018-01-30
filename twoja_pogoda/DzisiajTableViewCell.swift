//
//  DzisiajTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 24.01.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit

class DzisiajTableViewCell: UITableViewCell {

    @IBOutlet weak var dzisiajLabel: UILabel!
    @IBOutlet weak var wiatrLabel: UILabel!
    @IBOutlet weak var deszczLabel: UILabel!
    @IBOutlet weak var opisLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ustawKolory() {
        dzisiajLabel.textColor = zapisaneKolory.dzien
        opisLabel.textColor = zapisaneKolory.opis
        tempLabel.textColor = zapisaneKolory.temp
        wiatrLabel.textColor = zapisaneKolory.wiatr
        deszczLabel.textColor = zapisaneKolory.deszcz
    }

}

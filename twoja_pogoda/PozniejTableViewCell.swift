//
//  PozniejTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 24.01.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit

class PozniejTableViewCell: UITableViewCell {

    @IBOutlet weak var nocLabel: UILabel!
    @IBOutlet weak var dzienLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dzienOpisLabel: UILabel!
    @IBOutlet weak var dzienTempLabel: UILabel!
    @IBOutlet weak var nocTempLabel: UILabel!
    @IBOutlet weak var nocOpisLabel: UILabel!
    @IBOutlet weak var dzienView: UIView!
    @IBOutlet weak var nocView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ustawKolory() {
        dzienView.backgroundColor = zapisaneKolory.tlo
        nocView.backgroundColor = zapisaneKolory.tlo
        dataLabel.textColor = zapisaneKolory.dzien
        dzienOpisLabel.textColor = zapisaneKolory.opis
        nocOpisLabel.textColor = zapisaneKolory.opis
        dzienTempLabel.textColor = zapisaneKolory.temp
        nocTempLabel.textColor = zapisaneKolory.temp
        dzienLabel.textColor = zapisaneKolory.godzina
        nocLabel.textColor = zapisaneKolory.godzina
    }

}

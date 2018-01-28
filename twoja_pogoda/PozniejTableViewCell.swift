//
//  PozniejTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 24.01.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit

class PozniejTableViewCell: UITableViewCell {

    @IBOutlet weak var dzienOpisLabel: UILabel!
    @IBOutlet weak var dzienTempLabel: UILabel!
    @IBOutlet weak var nocTempLabel: UILabel!
    @IBOutlet weak var nocOpisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

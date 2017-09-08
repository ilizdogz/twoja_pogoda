//
//  MiejsceTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class MiejsceTableViewCell: UITableViewCell {

    @IBOutlet weak var miejsceLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var deszczLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func wypelnij(miejsce: String, temp: Double, deszcz: Double) {
        miejsceLabel.text = miejsce
        tempLabel.text = "\(String(format: "%.2f", temp)) \(formatTemp.rawValue)"
        deszczLabel.text = "\(String(format: "%.2f", deszcz)) mm"
    }
    
    func zmienKolory(kolory: ZapisaneKolory) {
        tempLabel.textColor = kolory.temp
        deszczLabel.textColor = kolory.deszcz
        let tlo = kolory.tlo.cgColor
        let jasnoscR = tlo.components![0] * 0.299
        let jasnoscG = tlo.components![1] * 0.587
        let jasnoscB = tlo.components![2] * 0.114
        //czy przyciski powinny być jasne czy ciemne?
        let jasnoscTla = 1 - (jasnoscR + jasnoscG + jasnoscB)
        if jasnoscTla < 0.5 {
            //tło jest jasne - potrzebne są ciemne kolory
            miejsceLabel.textColor = Kolory.navCont
        } else {
            //tło jest ciemne - portrzebne są jasne kolory
            miejsceLabel.textColor = Kolory.bialy
        }
    }

}

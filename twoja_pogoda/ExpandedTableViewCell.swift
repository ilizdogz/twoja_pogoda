//
//  TodayExpandedTableViewCell.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 25.08.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit
import YourWeatherFramework

class ExpandedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreLessLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabels(item: Next24hModel) {
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.layer.bounds.size.width / 2, 0, 0)
        }
        cloudLabel.text = "\(NSLocalizedString("clouds", comment: "clouds")): \(item.clouds)%"
        pressureLabel.text = "\(NSLocalizedString("pressure", comment: "pressure")): \(item.pressure) hPa"
        humidityLabel.text = "\(NSLocalizedString("humidity", comment: "humidity")): \(item.humidity)%"
//        slide in
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        layer.add(transition, forKey: nil)
    }
    
    func setColors() {
        cloudLabel.textColor = UIColor.white
        pressureLabel.textColor = UIColor.white
        humidityLabel.textColor = UIColor.white
    }

}

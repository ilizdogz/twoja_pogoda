//
//  PogodaTableViewController+delegate.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

extension WeatherTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard (model != nil) else { return 0 }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        if let offset = storedOffset[collectionView.tag] {
            collectionView.contentOffset.x = offset
        } else {
            collectionView.contentOffset.x = 0
            storedOffset[collectionView.tag] = collectionView.contentOffset.x
        }
//        }
        collectionView.backgroundColor = savedColors!.bg
        return model!.next24h.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pogodaCV",
                                                      for: indexPath) as! WeatherCollectionViewCell
        guard (model != nil) else { return cell }
        let item = model!.next24h[indexPath.item]
        //print(godzina)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.hourLabel.text = dateFormatter.string(from: item.time)
        cell.tempLabel.text = "\(String(format: "%.2f", item.temp.returnFormat(tempUnit))) \(tempUnit.rawValue)"
        cell.descLabel.text = (item.desc)
        cell.hourLabel.textColor = savedColors.hour
        cell.tempLabel.textColor = savedColors.temp
        cell.descLabel.textColor = savedColors.desc
        cell.backgroundColor = savedColors.bg
        
        
        return cell
    }
    
}

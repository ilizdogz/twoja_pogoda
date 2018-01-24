//
//  PogodaTableViewController+delegate.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

extension PogodaTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard (model != nil) else { return 0 }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        if dateFormatter.string(from: model[collectionView.tag][0].godzina) != dateFormatter.string(from: Date()) {
            if let offset = storedOffset[collectionView.tag] {
                collectionView.contentOffset.x = offset
            } else {
                collectionView.contentOffset.x = 2 * 240
                storedOffset[collectionView.tag] = collectionView.contentOffset.x
            }
            
        } else {
            if let offset = storedOffset[collectionView.tag] {
                collectionView.contentOffset.x = offset
            } else {
                collectionView.contentOffset.x = 0
                storedOffset[collectionView.tag] = collectionView.contentOffset.x
            }
        }
        collectionView.backgroundColor = zapisaneKolory!.tlo
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pogoda",
                                                      for: indexPath) as! PogodaCollectionViewCell
        let godzina = model[collectionView.tag][indexPath.item]
        //print(godzina)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.dataGodz.text = dateFormatter.string(from: godzina.godzina)
        cell.temp.text = "\(String(format: "%.2f", godzina.temp.returnFormat())) \(formatTemp.rawValue)"
        cell.opis.text = (godzina.opis)
        cell.ciśnienie.text = "ciśnienie: \(godzina.ciśnienie) hPa"
        cell.wilgotność.text = "wilgotność: \(godzina.wilgotność) %"
        cell.zachmurzenie.text = " zachmurzenie: \(godzina.zachmurzenie) %"
        cell.wiatr.text = "wiatr: \(String(format: "%.2f",godzina.wiatr)) m/s"
        cell.deszcz.text = "deszcz: \(String(format: "%.2f", godzina.deszcz)) mm"
        cell.dataGodz.textColor = zapisaneKolory.godzina
        cell.temp.textColor = zapisaneKolory.temp
        cell.opis.textColor = zapisaneKolory.opis
        cell.ciśnienie.textColor = zapisaneKolory.cisnienie
        cell.wilgotność.textColor = zapisaneKolory.wilgotnosc
        cell.zachmurzenie.textColor = zapisaneKolory.zachmurzenie
        cell.wiatr.textColor = zapisaneKolory.wiatr
        cell.deszcz.textColor = zapisaneKolory.deszcz
        cell.backgroundColor = zapisaneKolory.tlo
        
        
        return cell
    }
    
}

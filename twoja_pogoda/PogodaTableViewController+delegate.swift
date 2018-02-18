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
        if let offset = storedOffset[collectionView.tag] {
            collectionView.contentOffset.x = offset
        } else {
            collectionView.contentOffset.x = 0
            storedOffset[collectionView.tag] = collectionView.contentOffset.x
        }
//        }
        collectionView.backgroundColor = zapisaneKolory!.tlo
        return model!.nast24h.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pogodaCV",
                                                      for: indexPath) as! PogodaCollectionViewCell
        guard (model != nil) else { return cell }
        let godzina = model!.nast24h[indexPath.item]
        //print(godzina)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.dataGodz.text = dateFormatter.string(from: godzina.godz)
        cell.temp.text = "\(String(format: "%.2f", godzina.temp.returnFormat(formatTemp))) \(formatTemp.rawValue)"
        cell.opis.text = (godzina.opis)
        cell.dataGodz.textColor = zapisaneKolory.godzina
        cell.temp.textColor = zapisaneKolory.temp
        cell.opis.textColor = zapisaneKolory.opis
        cell.backgroundColor = zapisaneKolory.tlo
        
        
        return cell
    }
    
}

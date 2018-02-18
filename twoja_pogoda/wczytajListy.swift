//
//  wczytajListy.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import SwiftyJSON

//nazwa miasta i kod panstwa -> URL
//func wczytajListy(name: String) -> [RodzajJSON: String]? {
//    //usuwanie polskich znakow
//    let nameEncoded = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
//
//    let stack = CoreDataStack()
//    if let items = stack.loadSavedData(name: nameEncoded) {
//        guard let item = items.first else { return nil }
//        return [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(item.id!)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(item.id!)&appid=\(apiKey)&lang=pl"]
//    }
//
//    return nil
//}

//func idToUrl(id: String) -> [RodzajJSON: String] {
//    return [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(id)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=\(apiKey)&lang=pl"]
//}



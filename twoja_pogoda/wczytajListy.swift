//
//  wczytajListy.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
//import CoreData
import SwiftyJSON
import Sync

//nazwa miasta i kod panstwa -> URL
func wczytajListy(name: String, country: String?) -> [RodzajJSON: String]? {
    /*
    var container: NSPersistentContainer!
    container = NSPersistentContainer(name: "cityList")
    container.loadPersistentStores { (storeDescription, error) in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unresolver error \(error)")
        }
    }
     */
    //usuwanie polskich znakow
    let nameEncoded = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
    let nazwyPlikow = ["cityList", "currentCityList"]
    for nazwa in nazwyPlikow {
        if let listFilePath = Bundle.main.path(forResource: nazwa, ofType: "json") {
            if let listContents = try? String(contentsOfFile: listFilePath) {
                let json = JSON.parse(listContents).arrayValue
                for i in 0 ..< json.count {
                   let item = json[i]
                    //kod kraju tylko przy uzywaniu lokalizacji
                    if let country = country {
                        if item["name"].stringValue.lowercased() == nameEncoded && item["country"].stringValue == country {
                            return [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl"]
                        }
                    } else {
                        if item["name"].stringValue.lowercased() == nameEncoded {
                            return [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl"]
                        }
                    }
                }
            }
        }
    }
    /*
    if container.viewContext.hasChanges{
        do {
            try container.viewContext.save()
        } catch {
            print("An error occured while saving: \(error)")
        }
    }
 */
    return nil
}



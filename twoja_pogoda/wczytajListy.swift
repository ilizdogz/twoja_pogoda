//
//  wczytajListy.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation

//nazwa miasta i kod panstwa -> URL
func wczytajListy(name: String, country: String?) -> [RodzajJSON: String]? {
    let nazwyPlikow = ["cityList", "currentCityList"]
    for nazwa in nazwyPlikow {
        if let listFilePath = Bundle.main.path(forResource: nazwa, ofType: "json") {
            if let listContents = try? String(contentsOfFile: listFilePath) {
                let json = JSON.parse(listContents).arrayValue
                for i in 0 ..< json.count {
                    let item = json[i]
                    if let country = country {
                        if item["name"].stringValue == name && item["country"].stringValue == country {
                            return [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl"]
                        }
                    } else {
                        if item["name"].stringValue == name {
                            return [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(item["id"].stringValue)&appid=\(apiKey)&lang=pl"]
                        }
                    }
                }
            }
        }
    }
    return nil
}


//
//  GetWeatherData.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 18.02.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import Foundation
import SwiftyJSON
import Timepiece

func getLang() -> String {
    if (Locale.current.identifier == "pl-PL") {
        return "&lang=pl"
    } else {
        return ""
    }
}

func getDataWithId(id: String) -> PogodaModel? {
    let urlArray: [RodzajJSON: String] = [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?id=\(id)&appid=\(apiKey)\(getLang())", .teraz: "https://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=\(apiKey)\(getLang())"]
    if let data = getWeatherData(urlArray) {
        return parse(data)
    } else {
        return nil
    }
}

func getDataWithLocation(lat: Double, lon: Double) -> PogodaModel? {
    let urlArray: [RodzajJSON: String] = [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)\(getLang())", .teraz: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)\(getLang())"]
    if let data = getWeatherData(urlArray) {
        return parse(data)
    } else {
        return nil
    }
}

func getWeatherData(_ array: [RodzajJSON: String]) -> [RodzajJSON: JSON]? {
    var results = [RodzajJSON: JSON]()
    for (rodzaj, adres) in array {
        if let url = URL(string: adres) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSON(data: data) {
                    if json["cod"].intValue == 200 {
                        results[rodzaj] = json
                    } else { return nil }
                }
            } else { return nil }
        } else { return nil }
    }
    return results
}

func parse(_ results: [RodzajJSON: JSON]) -> PogodaModel? {
    var dzisiaj: ModelDzisiaj?
    var nast24h: [ModelNast24h]?
    var pozniej: [ModelPozniej]?
    var cityName: String?
    for (typ, json) in results {
        switch typ {
        case .prognoza:
            cityName = "\(json["city"]["name"].stringValue), \(json["city"]["country"].stringValue)".lowercased()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .long
            var tempNast24h = [ModelNast24h]()
            var tempPozniej = [ModelPozniej]()
            for index in 0...json["list"].count {
                let obj = json["list"][index]
                let godzinaWInt = obj["dt"].intValue
                let godzina = Date(timeIntervalSince1970: TimeInterval(godzinaWInt))
                let temp = Temperatura(k: obj["main"]["temp"].doubleValue)
                let opis = obj["weather"][0]["description"].stringValue
                if (dzisiaj != nil && index == 0) {
                    if (obj["snow"]["3h"].doubleValue != 0 && dzisiaj!.snieg != 0) {
                        dzisiaj!.snieg = obj["snow"]["3h"].doubleValue
                    } else if (obj["rain"]["3h"].doubleValue != 0 && dzisiaj!.deszcz != 0) {
                        dzisiaj!.deszcz = obj["rain"]["3h"].doubleValue
                    }
                }
                if (index < 8) {
                    tempNast24h.append(ModelNast24h(godz: godzina, opis: opis, temp: temp))
                } else {
                    if (godzina.hour >= 21) {
                        tempPozniej.append(ModelPozniej(data: godzina, tempNoc: temp, opisNoc: opis))
                    } else if (godzina.hour > 11 && godzina.hour < 15) {
                        tempPozniej.append(ModelPozniej(data: godzina, tempDzien: temp, opisDzien: opis))
                    }
                }
                
            }
            var list = [ModelPozniej]()
            //            od 2, bo i tak bierzemy wczesniejszy
            for i in 1 ..< tempPozniej.count {
                let item = tempPozniej[i]
                let prevItem = tempPozniej[i - 1]
                if (item.data.day == prevItem.data.day && item.data.month == prevItem.data.month && item.data.year == prevItem.data.year) {
                    let items = [item, prevItem]
                    var modelPozniej = ModelPozniej(data: item.data)
                    for thing in items {
                        if let opisDzien = thing.opisDzien, let tempDzien = thing.tempDzien {
                            modelPozniej.opisDzien = opisDzien
                            modelPozniej.tempDzien = tempDzien
                        }
                        if let opisNoc = thing.opisNoc, let tempNoc = thing.tempNoc {
                            modelPozniej.opisNoc = opisNoc
                            modelPozniej.tempNoc = tempNoc
                        }
                    }
                    list.append(modelPozniej)
                } else if (i == 1) {
                    //pierwszy element to poprzednia noc
                    list.insert(ModelPozniej(data: prevItem.data, tempNoc: prevItem.tempNoc!, opisNoc: prevItem.opisNoc!), at: 0)
                }
            }
            nast24h = tempNast24h
            pozniej = list
        case .teraz:
            let temp = Temperatura(k: json["main"]["temp"].doubleValue)
            let opis = json["weather"][0]["description"].stringValue
            let wiatr = json["wind"]["speed"].doubleValue
            var deszcz: Double = 0
            var snieg: Double?
            if (json["snow"]["3h"].doubleValue != 0) {
                snieg = json["snow"]["3h"].doubleValue
            } else {
                deszcz = json["rain"]["3h"].doubleValue
            }
            dzisiaj = ModelDzisiaj(temp: temp, opis: opis, deszcz: deszcz, snieg: snieg, wiatr: wiatr)
        }
    }
    if let dzisiaj = dzisiaj,
        let nast24h = nast24h,
        let pozniej = pozniej,
        let cityName = cityName{
        return PogodaModel(dzisiaj: dzisiaj, nast24h: nast24h, pozniej: pozniej, cityName: cityName)
    } else {
        return nil
    }
}

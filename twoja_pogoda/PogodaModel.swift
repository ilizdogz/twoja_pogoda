//
//  Pogoda.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 06.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

struct PogodaModel {
//    var godzina: Date
//    var temp: Temperatura
//    var opis: String
//    var ciśnienie: Int
//    var wilgotność: String
//    var zachmurzenie: String
//    var wiatr: Double
//    var deszcz: Double
//    var okragleRogi: UIRectCorner?
    var dzisiaj: ModelDzisiaj
    var nast24h: [ModelNast24h]
    var pozniej: [ModelPozniej]
    
}

struct ModelDzisiaj {
    var temp: Temperatura
    var opis: String
    var deszcz: Double
    var snieg: Double?
    var wiatr: Double
}

struct ModelNast24h {
    var godz: Date
    var opis: String
    var temp: Temperatura
}

struct ModelPozniej {
    var data: Date
    var tempDzien: Temperatura?
    var opisDzien: String?
    var tempNoc: Temperatura?
    var opisNoc: String?
    init(data: Date, tempDzien: Temperatura, opisDzien: String) {
        self.tempDzien = tempDzien
        self.data = data
        self.opisDzien = opisDzien
//        self.tempNoc = nil
//        self.opisNoc = nil
    }
    init(data: Date, tempNoc: Temperatura, opisNoc: String) {
        self.data = data
        self.tempNoc = tempNoc
        self.opisNoc = opisNoc
//        self.opisDzien = nil
//        self.opisNoc = nil
    }
    init(data: Date) {
        self.data = data
    }
}


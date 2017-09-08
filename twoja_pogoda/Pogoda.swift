//
//  Pogoda.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 06.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

struct Pogoda {
    var godzina: Date
    var temp: Temperatura
    var opis: String
    var ciśnienie: Int
    var wilgotność: String
    var zachmurzenie: String
    var wiatr: Double
    var deszcz: Double
    var okragleRogi: UIRectCorner?
}

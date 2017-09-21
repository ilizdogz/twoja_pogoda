//
//  KoloryPogoda.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 01.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

var zapisaneKolory: ZapisaneKolory!

class ZapisaneKolory: NSObject, NSCoding {
    var dzien: UIColor
    var godzina: UIColor
    var temp: UIColor
    var opis: UIColor
    var cisnienie: UIColor
    var wilgotnosc: UIColor
    var zachmurzenie: UIColor
    var wiatr: UIColor
    var deszcz: UIColor
    var zapisaneMiejsce: UIColor
    var tlo: UIColor
    
    init(dzien: UIColor, godzina: UIColor, temp: UIColor, opis: UIColor, cisnienie: UIColor, wilgotnosc: UIColor, zachmurzenie: UIColor, wiatr: UIColor, deszcz: UIColor, zapisaneMiejsce: UIColor, tlo: UIColor) {
        self.dzien = dzien
        self.godzina = godzina
        self.temp = temp
        self.opis = opis
        self.cisnienie = cisnienie
        self.wilgotnosc = wilgotnosc
        self.zachmurzenie = zachmurzenie
        self.wiatr = wiatr
        self.deszcz = deszcz
        self.zapisaneMiejsce = zapisaneMiejsce
        self.tlo = tlo
    }
    
    struct PropertyKeys {
        static var dzien = "dzien"
        static var godzina = "godzina"
        static var temp = "temp"
        static var opis = "opis"
        static var cisnienie = "cisnienie"
        static var wilgotnosc = "wilgotnosc"
        static var zachmurzenie = "zachmurzenie"
        static var wiatr = "wiatr"
        static var deszcz = "deszcz"
        static var zapisaneMiejsce = "zapisaneMiejsce"
        static var tlo = "tlo"
    }
    
    required init?(coder aDecoder: NSCoder) {
        dzien = aDecoder.decodeObject(forKey: PropertyKeys.dzien) as! UIColor
        godzina = aDecoder.decodeObject(forKey: PropertyKeys.godzina) as! UIColor
        temp = aDecoder.decodeObject(forKey: PropertyKeys.temp) as! UIColor
        opis = aDecoder.decodeObject(forKey: PropertyKeys.opis) as! UIColor
        cisnienie = aDecoder.decodeObject(forKey: PropertyKeys.cisnienie) as! UIColor
        wilgotnosc = aDecoder.decodeObject(forKey: PropertyKeys.wilgotnosc) as! UIColor
        zachmurzenie = aDecoder.decodeObject(forKey: PropertyKeys.zachmurzenie) as! UIColor
        wiatr = aDecoder.decodeObject(forKey: PropertyKeys.wiatr) as! UIColor
        deszcz = aDecoder.decodeObject(forKey: PropertyKeys.deszcz) as! UIColor
        zapisaneMiejsce = aDecoder.decodeObject(forKey: PropertyKeys.zapisaneMiejsce) as! UIColor
        tlo = aDecoder.decodeObject(forKey: PropertyKeys.tlo) as! UIColor
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dzien, forKey: PropertyKeys.dzien)
        aCoder.encode(godzina, forKey: PropertyKeys.godzina)
        aCoder.encode(temp, forKey: PropertyKeys.temp)
        aCoder.encode(opis, forKey: PropertyKeys.opis)
        aCoder.encode(cisnienie, forKey: PropertyKeys.cisnienie)
        aCoder.encode(wilgotnosc, forKey: PropertyKeys.wilgotnosc)
        aCoder.encode(zachmurzenie, forKey: PropertyKeys.zachmurzenie)
        aCoder.encode(wiatr, forKey: PropertyKeys.wiatr)
        aCoder.encode(deszcz, forKey: PropertyKeys.deszcz)
        aCoder.encode(zapisaneMiejsce, forKey: PropertyKeys.zapisaneMiejsce)
        aCoder.encode(tlo, forKey: PropertyKeys.tlo)
    }
    
    static var domyslneUstawienia = ZapisaneKolory(dzien: Kolory.zoltyDzien, godzina: Kolory.bialy, temp: Kolory.zielonyDuze, opis: Kolory.zielonyDuze, cisnienie: Kolory.niebieskiMale, wilgotnosc: Kolory.niebieskiMale, zachmurzenie: Kolory.niebieskiMale, wiatr: Kolory.niebieskiMale, deszcz: Kolory.niebieskiDeszcz, zapisaneMiejsce: Kolory.bialy, tlo: Kolory.navCont)
}

enum CiemneJasne {
    case ciemne, jasne
}

struct Kolory {
    static var navCont = UIColor(red: 12/255, green: 25/255, blue: 45/255, alpha: 1)
    static var tableView = UIColor(red: 23/255, green: 46/255, blue: 84/255, alpha: 1)
    static var czarnyPrzezr = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    static var bialyPrzezr = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    static var zoltyDzien = UIColor(hexString: "FFC70B")
    static var bialy = UIColor.white
    static var godzinaBG = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    static var zielonyDuze = UIColor(hexString: "3EFD86")
    static var niebieskiMale = UIColor(hexString: "61DAD2")
    static var niebieskiDeszcz = UIColor(hexString: "5E9CFF")
    
    static func ciemneCzyJasne(kolorTla: UIColor) -> CiemneJasne {
        let cgColor = kolorTla.cgColor
        let jasnoscR = cgColor.components![0] * 0.299
        let jasnoscG = cgColor.components![1] * 0.587
        let jasnoscB = cgColor.components![2] * 0.114
        //czy przyciski powinny być jasne czy ciemne?
        let jasnoscTla = 1 - (jasnoscR + jasnoscG + jasnoscB)
        if jasnoscTla < 0.5 {
            //tło jest jasne - potrzebne są ciemne kolory
            return .jasne
        } else {
            //tło jest ciemne - portrzebne są jasne kolory
            return .ciemne
        }
    }
}

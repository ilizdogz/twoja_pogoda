//
//  ColorsPogoda.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 01.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit

var savedColors: SavedColors!

class SavedColors: NSObject, NSCoding {
    var day: UIColor
    var hour: UIColor
    var temp: UIColor
    var desc: UIColor
    var wind: UIColor
    var rain: UIColor
    var savedCity: UIColor
    var bg: UIColor
    
    init(day: UIColor, hour: UIColor, temp: UIColor, desc: UIColor, wind: UIColor, rain: UIColor, savedCity: UIColor, bg: UIColor) {
        self.day = day
        self.hour = hour
        self.temp = temp
        self.desc = desc
        self.wind = wind
        self.rain = rain
        self.savedCity = savedCity
        self.bg = bg
    }
    
    struct PropertyKeys {
        static var day = "day"
        static var hour = "hour"
        static var temp = "temp"
        static var desc = "desc"
        static var wind = "wind"
        static var rain = "rain"
        static var savedCity = "savedCity"
        static var bg = "bg"
    }
    
    required init?(coder aDecoder: NSCoder) {
        day = aDecoder.decodeObject(forKey: PropertyKeys.day) as! UIColor
        hour = aDecoder.decodeObject(forKey: PropertyKeys.hour) as! UIColor
        temp = aDecoder.decodeObject(forKey: PropertyKeys.temp) as! UIColor
        desc = aDecoder.decodeObject(forKey: PropertyKeys.desc) as! UIColor
        wind = aDecoder.decodeObject(forKey: PropertyKeys.wind) as! UIColor
        rain = aDecoder.decodeObject(forKey: PropertyKeys.rain) as! UIColor
        savedCity = aDecoder.decodeObject(forKey: PropertyKeys.savedCity) as! UIColor
        bg = aDecoder.decodeObject(forKey: PropertyKeys.bg) as! UIColor
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(day, forKey: PropertyKeys.day)
        aCoder.encode(hour, forKey: PropertyKeys.hour)
        aCoder.encode(temp, forKey: PropertyKeys.temp)
        aCoder.encode(desc, forKey: PropertyKeys.desc)
        aCoder.encode(wind, forKey: PropertyKeys.wind)
        aCoder.encode(rain, forKey: PropertyKeys.rain)
        aCoder.encode(savedCity, forKey: PropertyKeys.savedCity)
        aCoder.encode(bg, forKey: PropertyKeys.bg)
    }
    
    static var defaultSettings = SavedColors(day: Colors.yellowDay, hour: UIColor.white, temp: Colors.greenBigText, desc: Colors.greenBigText, wind: Colors.blueSmallText, rain: Colors.blueRain, savedCity: UIColor.white, bg: Colors.navCont)
}

struct Colors {
    static var navCont = UIColor(red: 40/255, green: 42/255, blue: 54/255, alpha: 1)
    static var tableView = UIColor(red: 23/255, green: 46/255, blue: 84/255, alpha: 1)
    static var blackAlpha = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    static var whiteAlpha = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    static var yellowDay = UIColor(hexString: "FFC70B")
    static var hourBG = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    static var greenBigText = UIColor(hexString: "3EFD86")
    static var blueSmallText = UIColor(hexString: "61DAD2")
    static var blueRain = UIColor(hexString: "5E9CFF")
    
    static func isDark(_ bgColor: UIColor) -> Bool {
        let cgColor = bgColor.cgColor
        let brightR = cgColor.components![0] * 0.299
        let brightG = cgColor.components![1] * 0.587
        let brightB = cgColor.components![2] * 0.114
        //czy przyciski powinny być jasne czy ciemne?
        let brightness = 1 - (brightR + brightG + brightB)
        if brightness < 0.5 {
            //background is light
            return false
        } else {
            //background is dark
            return true
        }
    }
}

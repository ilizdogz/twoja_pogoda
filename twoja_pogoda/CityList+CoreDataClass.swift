//
//  CityList+CoreDataClass.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CityList)
public class CityList: NSManagedObject {
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

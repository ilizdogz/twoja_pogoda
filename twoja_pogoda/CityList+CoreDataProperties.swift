//
//  CityList+CoreDataProperties.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//
//

import Foundation
import CoreData


extension CityList {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CityList> {
        return NSFetchRequest<CityList>(entityName: "CityList")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var country: String

}

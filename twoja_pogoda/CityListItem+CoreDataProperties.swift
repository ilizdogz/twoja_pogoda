//
//  CityListItem+CoreDataProperties.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//
//

import Foundation
import CoreData


extension CityListItem {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CityListItem> {
        return NSFetchRequest<CityListItem>(entityName: "CityListItem")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?

}

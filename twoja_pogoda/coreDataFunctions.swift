//
//  coreDataFunctions.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//
/*
import Foundation
import CoreData
import SwiftyJSON

class CityListModel {
    var fetchedResultsController: NSFetchedResultsController<CityList>
    var container: NSPersistentContainer!
    @objc func fetchCityList(nazwa: String) {
        if let listFilePath = Bundle.main.path(forResource: nazwa, ofType: "json") {
            if let listContents = try? String(contentsOfFile: listFilePath) {
                let json = JSON.init(parseJSON: listContents)
                let jsonArray = json.arrayValue
                
                for listItem in jsonArray {
                    let item = CityList(context: self.container.viewContext)
                    self.configure(cityList: item, json: listItem)
                }
            }
        }
    }
    
    var listItems = [CityList]()
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = CityList.createFetchRequest()
            let sort = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil))
        }
        
        fetchedResultsController.fetchRequest.predicate = 
        
        
        
        do {
            listItems = try container.viewContext.fetch(request)
            print("Got \(listItems.count) cities")
        } catch {
            print("Fetch failed")
        }
    }
    
    func configure(cityList: CityList, json: JSON) {
        cityList.id = json["id"].stringValue
        cityList.name = json["name"].stringValue
        cityList.country = json["country"].stringValue
    }
}
*/


//
//  CoreDataStack.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 23.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "twoja_pogoda")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    //niepotrzebne? - tylko wczytywanie zapisanych wczesniej danych
    /*
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Items saved.")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    @objc func fetchCityLists() {
        if let filePath = Bundle.main.path(forResource: "cityList", ofType: "json") {
            if let data = try? String(contentsOfFile: filePath) {
                let json = JSON.init(parseJSON: data)
                let jsonArray = json.arrayValue
                print("Received \(jsonArray.count) items.")
                for item in jsonArray {
                    let cityListItem = CityListItem(context: self.persistentContainer.viewContext)
                    self.configure(cityListItem, usingJSON: item)
                }
                print("Saving items...")
                self.saveContext()
                
            }
        }
    }
    
    func configure(_ cityListItem: CityListItem, usingJSON json: JSON) {
        cityListItem.name = json["name"].stringValue
        cityListItem.country = json["country"].stringValue
        cityListItem.id = json["id"].stringValue
    }
     */
    
    func loadSavedData(name: String, country: String?) -> [CityListItem]? {
        let request = CityListItem.createFetchRequest()
        let namePredicate = NSPredicate(format: "name == %@", name)
        if let country = country {
            let countryPredicate = NSPredicate(format: "country == %@", country)
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, countryPredicate])
            request.predicate = andPredicate
        } else {
            request.predicate = namePredicate
        }
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        do {
            let data = try persistentContainer.viewContext.fetch(request)
            return data
        } catch {
            return nil
        }
    }
    
    func preloadDbData() {
        let sqlitePath = Bundle.main.path(forResource: "coreDataManualImport", ofType: "sqlite")
        let sqliteShmPath = Bundle.main.path(forResource: "coreDataManualImport", ofType: "sqlite-shm")
        let sqliteWalPath = Bundle.main.path(forResource: "coreDataManualImport", ofType: "sqlite-wal")
        
        let URL1 = URL(fileURLWithPath: sqlitePath!)
        let URL2 = URL(fileURLWithPath: sqliteShmPath!)
        let URL3 = URL(fileURLWithPath: sqliteWalPath!)
        let URL4 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/twoja_pogoda.sqlite")
        let URL5 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/twoja_pogoda.sqlite-shm")
        let URL6 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/twoja_pogoda.sqlite-wal")
        
        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/twoja_pogoda.sqlite") {
            // Copy 3 files
            do {
                try FileManager.default.copyItem(at: URL1, to: URL4)
                try FileManager.default.copyItem(at: URL2, to: URL5)
                try FileManager.default.copyItem(at: URL3, to: URL6)
                
            } catch {
            }
        } else {
        }
    }
}

//
//  ZapisaneTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit
//import SwiftyJSON
import YourWeatherFramework

class SavedTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var edit: UIBarButtonItem!
//    var timestamp: Date?
    
    //var zapisaneMiejsca = [String]()
    var savedIds = [String]()
    var weatherArray = [WeatherModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //wyglad to wszystko
        
        
        //self.tableView.backgroundColor = Kolory.navCont
        /*dodaj.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        edytuj.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)*/
        
        //do przewijania do gory przez tabBar
        self.tabBarController?.delegate = self
        
        let backButton = UIBarButtonItem(title: NSLocalizedString("back", comment: "back"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        //backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        
        //wczytywanie/zapisywanie
        loadIds()
        navigationController?.navigationBar.barTintColor = Colors.blackAlpha
        self.save()
        refreshControl?.beginRefreshingManually()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //odswiez przy ponownym otwarciu
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        self.tableView.backgroundColor = savedColors.bg
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weatherArray.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "place", for: indexPath) as! PlaceTableViewCell
        let weather = weatherArray[indexPath.row]
        // Configure the cell...
        var rain: Double?
        if let snow = weather.today.snow {
            rain = snow
            cell.rainLabel.textColor = UIColor.white
        } else {
            rain = weather.today.rain
        }
        cell.fillLabels(place: weather.cityName, temp: weather.today.temp.returnFormat(tempUnit), rain: rain!)
        cell.changeColors(colors: savedColors)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Weather") as? WeatherTableViewController {
            vc.cityId = savedIds[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //pozwala na usuwanie
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            savedIds.remove(at: indexPath.row)
            weatherArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.save()
        }
    }
    

    //dodawanie miejsca po wybraniu dodaj
    @IBAction func addCity(_ sender: UIBarButtonItem) {
//        sender.isEnabled = false
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "search") as? SearchTableViewController else { return }
        vc.isAdding = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func submit(miasto: String) {
        //let lowerMiasto = miasto.lowercased()
        let stack = CoreDataStack()
        let items = stack.loadSavedData(name: miasto)
        if let items = items, let item = items.first {
            let id = item.id!
            savedIds.append(id)
            
            let indexPath = IndexPath(row: weatherArray.count, section: 0)
//            znajdzPogode(id: id)
            getDataWithId(id: id, apiKey: apiKey, callback: { (data, err) in
                if err != nil {
                    self.showError()
                    self.refreshControl?.endRefreshing()
                    
                } else {
                    self.weatherArray.append(data!)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.save()
                }
            })
        } else {
            let ac = UIAlertController(title: NSLocalizedString("not_found_header", comment: "not_found_header"), message: NSLocalizedString("not_found_msg", comment: "not_found_msg"), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    //edytowanie miejsca po wybraniu edytuj
    @IBAction func editCity(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    //zmien miejsce na liscie
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedId = savedIds.remove(at: sourceIndexPath.row)
        let movedWeather = weatherArray.remove(at: sourceIndexPath.row)
        savedIds.insert(movedId, at: destinationIndexPath.row)
        weatherArray.insert(movedWeather, at: destinationIndexPath.row)
        tableView.reloadData()
        self.save()
    }
    
    //przewin do gory przez przycisk w UITabBar
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    //zaladuj/wczytaj zapisane miejsca
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(savedIds, forKey: "zapisaneMiejsca")
    }
    
    func loadIds() {
        let defaults = UserDefaults.standard
        savedIds = defaults.object(forKey: "zapisaneMiejsca") as? [String] ?? ["5128638"]
    }
    
    //zaladuj pogode z zapisaneMiejsca
    
    @objc func loadWeather() {
        for id in savedIds {
            getDataWithId(id: id, apiKey: apiKey, callback: { (data, err) in
                if err != nil {
                    self.performSelector(onMainThread: #selector(self.showError), with: nil, waitUntilDone: false)
                    self.refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                } else {
                    self.weatherArray.append(data!)
                }
            })
        }
        DispatchQueue.main.async { [unowned self] in
            self.navigationItem.title = NSLocalizedString("saved_places_header", comment: "saved_places_header")
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: NSLocalizedString("error_header", comment: "error_header"), message: NSLocalizedString("loading_error", comment: "loading_error"), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    //odśwież
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        let places: [String] = savedIds
        savedIds.removeAll(keepingCapacity: false)
        weatherArray.removeAll(keepingCapacity: false)
        savedIds.removeAll(keepingCapacity: false)
        tableView.reloadData()
        savedIds = places
        self.navigationItem.title = NSLocalizedString("loading", comment: "loading")
        performSelector(inBackground: #selector(loadWeather), with: nil)
    }
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        refreshControl?.beginRefreshingManually()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindToSaved",
            let source = segue.source as? SearchTableViewController else { return }
        if let id = source.selectedId {
            savedIds.append(id)
            save()
            refreshControl?.beginRefreshingManually()
        }
        
    }
    
}

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

class ZapisaneTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var dodaj: UIBarButtonItem!
    @IBOutlet weak var edytuj: UIBarButtonItem!
//    var timestamp: Date?
    
    //var zapisaneMiejsca = [String]()
    var zapisaneId = [String]()
    var pogoda = [PogodaModel]()
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
        
        let backButton = UIBarButtonItem(title: NSLocalizedString("back", comment: "back"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        //backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        
        //wczytywanie/zapisywanie
        wczytajMiejsca()
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        self.zapisz()
        refreshControl?.beginRefreshingManually()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //odswiez przy ponownym otwarciu
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        self.tableView.backgroundColor = zapisaneKolory.tlo
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
            return pogoda.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miejsce", for: indexPath) as! MiejsceTableViewCell
        let pogodaW = pogoda[indexPath.row]
        let temperatura = pogodaW.dzisiaj.temp
        // Configure the cell...
        var opady: Double?
        if let snieg = pogodaW.dzisiaj.snieg {
            opady = snieg
            cell.deszczLabel.textColor = Kolory.bialy
        } else {
            opady = pogodaW.dzisiaj.deszcz
        }
        cell.wypelnij(miejsce: pogodaW.cityName, temp: temperatura.returnFormat(formatTemp), deszcz: opady!)
        cell.zmienKolory(kolory: zapisaneKolory)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Pogoda") as? PogodaTableViewController {
            vc.idMiasta = zapisaneId[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //pozwala na usuwanie
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            zapisaneId.remove(at: indexPath.row)
            pogoda.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.zapisz()
        }
    }
    

    //dodawanie miejsca po wybraniu dodaj
    @IBAction func dodajMiejsce(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "search") as? WyszukajTableViewController else { return }
        vc.isAdding = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func submit(miasto: String) {
        //let lowerMiasto = miasto.lowercased()
        let stack = CoreDataStack()
        let items = stack.loadSavedData(name: miasto)
        if let items = items, let item = items.first {
            let id = item.id!
            zapisaneId.append(id)
            
            let indexPath = IndexPath(row: pogoda.count, section: 0)
//            znajdzPogode(id: id)
            getDataWithId(id: id, apiKey: apiKey, callback: { (data, err) in
                if err != nil {
                    self.showError()
                    self.refreshControl?.endRefreshing()
                    
                } else {
                    self.pogoda.append(data!)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.zapisz()
                }
            })
        } else {
            let ac = UIAlertController(title: NSLocalizedString("not_found_header", comment: "not_found_header"), message: NSLocalizedString("not_found_msg", comment: "not_found_msg"), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    //edytowanie miejsca po wybraniu edytuj
    @IBAction func edytujMiasta(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    //zmien miejsce na liscie
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let przeniesioneMiasto = zapisaneId.remove(at: sourceIndexPath.row)
        let przeniesionaPogoda = pogoda.remove(at: sourceIndexPath.row)
        zapisaneId.insert(przeniesioneMiasto, at: destinationIndexPath.row)
        pogoda.insert(przeniesionaPogoda, at: destinationIndexPath.row)
        tableView.reloadData()
        self.zapisz()
    }
    
    //przewin do gory przez przycisk w UITabBar
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    //zaladuj/wczytaj zapisane miejsca
    func zapisz() {
        let defaults = UserDefaults.standard
        defaults.set(zapisaneId, forKey: "zapisaneMiejsca")
    }
    
    func wczytajMiejsca() {
        let defaults = UserDefaults.standard
        zapisaneId = defaults.object(forKey: "zapisaneMiejsca") as? [String] ?? ["5128638"]
    }
    
    //zaladuj pogode z zapisaneMiejsca
    
    @objc func zaladujPogode() {
        for miejsce in zapisaneId {
//            znajdzPogode(id: miejsce)
            getDataWithId(id: miejsce, apiKey: apiKey, callback: { (data, err) in
                if err != nil {
                    self.performSelector(onMainThread: #selector(self.showError), with: nil, waitUntilDone: false)
                    self.refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                } else {
                    self.pogoda.append(data!)
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
        let miejsca: [String] = zapisaneId
        zapisaneId.removeAll(keepingCapacity: false)
        pogoda.removeAll(keepingCapacity: false)
        zapisaneId.removeAll(keepingCapacity: false)
        tableView.reloadData()
        zapisaneId = miejsca
        self.navigationItem.title = NSLocalizedString("loading", comment: "loading")
        performSelector(inBackground: #selector(zaladujPogode), with: nil)
    }
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        refreshControl?.beginRefreshingManually()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindToSaved",
            let source = segue.source as? WyszukajTableViewController else {
                print("Wrong source!")
                return
        }
        if let id = source.selectedId {
            zapisaneId.append(id)
            zapisz()
            refreshControl?.beginRefreshingManually()
        }
        
    }
    
}

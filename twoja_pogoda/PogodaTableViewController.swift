//
//  PogodaTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit
import CoreLocation
import YourWeatherFramework

class PogodaTableViewController: UITableViewController, UITabBarControllerDelegate, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var lokalizacja: CLLocation?
    
    @IBOutlet weak var pogodaViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var pogodaViewLeading: NSLayoutConstraint!
    //var model: [[[String: Any]]] = [[[String: Any]]]()
    var model: PogodaModel?
    //var miasto: String?
    var idMiasta: String?
    var znalazlLokalizacje = false
    var proba: Int = 0
    var storedOffset = [Int: CGFloat]()
//    var objArray: PogodaModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        //wyglad to wszystko
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 240
        
        
        //przewijanie do gory przez tabBar
        self.tabBarController?.delegate = self
    }
    struct  PropertyKeys {
        //"godzina": godzina, "tempWK": tempWK, "opis": opis, "ciśnienie": ciśnienie, "wilgotność": wilgotność, "zachmurzenie": zachmurzenie, "wiatr": wiatr, "deszcz": deszcz
        static var godzina = "godzina"
        static var tempWK = "tempWK"
        static var opis = "opis"
        static var ciśnienie = "ciśnienie"
        static var wilgotność = "wilgotność"
        static var zachmurzenie = "zachmurzenie"
        static var wiatr = "wiatr"
        static var deszcz = "deszcz"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.refreshControl?.beginRefreshingManually()
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        //kolory tutaj jakby ktos zmienil ustawienia i potem wrocil
        self.tableView.backgroundColor = zapisaneKolory.tlo
        self.tableView.backgroundView?.backgroundColor = zapisaneKolory.tlo
        /*
        let czyCiemne = Kolory.ciemneCzyJasne(kolorTla: zapisaneKolory.tlo)
        switch czyCiemne {
        case .ciemne:
            return
        case .jasne:
            return
        }
        */
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
        if (model == nil) {
            return 0
        } else {
            return 2 + model!.pozniej.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DzisiajCell", for: indexPath) as! DzisiajTableViewCell
            let dzisiaj = model!.dzisiaj
            cell.tempLabel.text = "\(String(format: "%.2f", dzisiaj.temp.returnFormat(formatTemp))) \(formatTemp.rawValue)"
            cell.opisLabel.text = dzisiaj.opis
            if let snieg = dzisiaj.snieg {
                cell.deszczLabel.text = "\(NSLocalizedString("snow", comment: "snow")): \(String(format: "%.2f", snieg)) mm"
            } else {
                if (dzisiaj.temp.c <= 0 && dzisiaj.deszcz == 0) {
                    cell.deszczLabel.text = "\(NSLocalizedString("snow", comment: "snow")): 0.00 mm"
                } else {
                    cell.deszczLabel.text = "\(NSLocalizedString("rain", comment: "rain")): \(String(format: "%.2f", dzisiaj.deszcz)) mm"
                }
            }
            cell.wiatrLabel.text = "\(NSLocalizedString("wind", comment: "wind")): \(String(format: "%.2f", dzisiaj.wiatr)) m/s"
            cell.ustawKolory()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Nast24Cell", for: indexPath) as! Nast24hTableViewCell
            cell.backgroundColor = zapisaneKolory.tlo
            cell.pogodaView.backgroundColor = zapisaneKolory.tlo
            cell.nast24hLabel.textColor = zapisaneKolory.dzien
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PozniejCell", for: indexPath) as! PozniejTableViewCell
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd/MM/yyyy"
            formatter.locale = Locale(identifier: Locale.current.identifier)
            let item = model!.pozniej[indexPath.row - 2]
            cell.dataLabel.text = formatter.string(from: item.data).lowercased()
            if let tempDzien = item.tempDzien, let opisDzien = item.opisDzien {
                cell.dzienTempLabel.text = "\(String(format: "%.2f", tempDzien.returnFormat(formatTemp))) \(formatTemp.rawValue)"
                cell.dzienOpisLabel.text = opisDzien
            } else {
                cell.dzienView.isHidden = true
            }
            if let tempNoc = item.tempNoc, let opisNoc = item.opisNoc {
                cell.nocTempLabel.text = "\(String(format: "%.2f", tempNoc.returnFormat(formatTemp))) \(formatTemp.rawValue)"
                cell.nocOpisLabel.text = opisNoc
            } else {
                cell.nocView.isHidden = true
            }
            cell.ustawKolory()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            //dzisiaj
            return 200
        case 1:
            //następne 24h
            return 220
        default:
            //później
            return 210
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? Nast24hTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? Nast24hTableViewCell else { return }
        
        storedOffset[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //przewijanie do gory przez tabBar
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 1 {
            self.tableView.setContentOffset(CGPoint(x: 0,y: -60), animated: true)
        }
    }
    
    @objc func sprawdzNazweMiasta() {
        if let id = idMiasta {
            if let data = getDataWithId(id: id, apiKey: apiKey) {
                model = data
                navigationItem.title = model!.cityName
                refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                tableView.reloadData()
            } else {
                showError()
                refreshControl?.endRefreshing()
            }
        } else {
            zlokalizujMnie()
        }
    }
    
    //lokalizacja
    func zlokalizujMnie() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lokalizacja = locations[0]
        proba += 1
        zrobUrl()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse || status != .authorizedAlways {
            let ac = UIAlertController(title: NSLocalizedString("error_header", comment: "errorHeader"), message: NSLocalizedString("permission_error", comment: "permissionError"), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
    }
    
    
    
    func zrobUrl() {
        //uzywa lat i lon z lokalizacji do zrobienia 2 URL - obecnej pogody i progozy
        if let lok = lokalizacja,
            proba == 1 {
                let lat = lok.coordinate.latitude
                let lon = lok.coordinate.longitude
            if let data = getDataWithLocation(lat: lat, lon: lon, apiKey: apiKey) {
                model = data
                navigationItem.title = model!.cityName
                refreshControl?.endRefreshing()
                tableView.reloadData()
            } else {
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
            }
        } else if proba > 1 {
            //zeby sie nie odswiezalo pare razy po tym jak juz znalazlo miejsce, zwykle dokladnosc 1 wystarcza
            return
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
            return
        }
    }
    
    //odswiez, pokaz wskaznik ladowania
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        model = nil
        self.tableView.reloadData()
        proba = 0
        lokalizacja = nil
//        objArray.removeAll(keepingCapacity: false)
        self.navigationItem.title = NSLocalizedString("loading", comment: "loading")
        performSelector(inBackground: #selector(sprawdzNazweMiasta), with: nil)
    }
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        self.refreshControl?.beginRefreshingManually()
    }
    
    
    
    //pokaz blad jak cos pojdzie nie tak
    @objc func showError() {
        let ac = UIAlertController(title: NSLocalizedString("error_header", comment: "errorHeader"), message: NSLocalizedString("loading_error", comment: "loadingError"), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    

}



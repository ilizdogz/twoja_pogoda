//
//  PogodaTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Timepiece

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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Nast24Cell", for: indexPath) as! Nast24hTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PozniejCell", for: indexPath) as! PozniejTableViewCell
            return cell
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PogodaTableViewCell
//
//        // Configure the cell...
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
//        let weekFormatter = DateFormatter()
//        weekFormatter.dateFormat = "EEEE"
//        let weekDay = weekFormatter.string(from: model[indexPath.row][0].godzina)
//        cell.dataLabel.text = "\(weekDay), \(dateFormatter.string(from: model[indexPath.row][0].godzina))"
//        //cell.ustawRogi()
//        cell.dataLabel.textColor = zapisaneKolory.dzien
//        cell.backgroundColor = zapisaneKolory.tlo
//        cell.pogodaView.backgroundColor = zapisaneKolory.tlo
//        return cell
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
            let urlArray = idToUrl(id: id)
            for (rodzaj, adres) in urlArray {
                zaladujPogode(adres: adres, typ: rodzaj)
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
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            return
        } else {
            let ac = UIAlertController(title: "Wystąpił błąd", message: "Aplikacja nie ma zgody na uzyskanie lokalizacji. Użyj innej opcji lub zmień to ustawienie.", preferredStyle: .alert)
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
            let urlArray: [RodzajJSON: String] = [.prognoza: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&lang=pl", .teraz: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&lang=pl"]
            for (rodzaj, adres) in urlArray {
                zaladujPogode(adres: adres, typ: rodzaj)
            }
            /*
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
                geocoder.reverseGeocodeLocation(lok, completionHandler: { (placemarks, error) in
                    self.processResponse(withPlacemarks: placemarks, error: error)
                })
                */
        } else if proba > 1 {
            //zeby sie nie odswiezalo pare razy po tym jak juz znalazlo miejsce, zwykle dokladnosc 1 wystarcza
            return
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
            return
        }
    }
    
    /*
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            showError()
        } else {
            /*
            if let places = placemarks, let locality = places.first?.locality , let countryCode = places.first?.isoCountryCode {
                if let urlArray = wczytajListy(name: locality, country: countryCode) {
                    for (rodzaj, adres) in urlArray {
                        zaladujPogode(adres: adres, typ: rodzaj)
                    }
                } else {
                    showError()
                }
            } else {
                showError()
            }
            */
            
                
            }
        }
        
        refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    */
    
    //JSON
    func zaladujPogode(adres: String, typ: RodzajJSON) {
        if let url = URL(string: adres) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["cod"].intValue == 200 {
                    self.parse(json: json, typ: typ)
                    return
                } else {
                    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                    refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                    return

                }
            } else {
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                return

            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
            return

        }
    }
    func parse(json: JSON, typ: RodzajJSON) {
        var dzisiaj: ModelDzisiaj?
        var nast24h =  [ModelNast24h]()
        var pozniej = [ModelPozniej]()
        switch typ {
        case .prognoza:
            var miasto = json["city"]["name"].stringValue
            miasto += ", "
            miasto += json["city"]["country"].stringValue
            DispatchQueue.main.async { [unowned self] in
                self.navigationItem.title = miasto.lowercased()
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .long
            var tempPozniej = [ModelPozniej]()
            for index in 0...json["list"].count {
                let obj = json["list"][index]
                let godzinaWInt = obj["dt"].intValue
                let godzina = Date(timeIntervalSince1970: TimeInterval(godzinaWInt))
                let temp = Temperatura(k: obj["main"]["temp"].doubleValue)
                let opis = obj["weather"][0]["description"].stringValue
                if (index < 8) {
//                    let wiatr = obj["wind"]["speed"].doubleValue
//                    let deszcz = obj["rain"]["3h"].doubleValue
                    nast24h.append(ModelNast24h(godz: godzina, opis: opis, temp: temp))
                } else {
                    if (godzina.hour < 2) {
                        tempPozniej.append(ModelPozniej(data: godzina, tempNoc: temp, opisNoc: opis))
                        
                    } else if (godzina.hour > 11 && godzina.hour < 15) {
                        tempPozniej.append(ModelPozniej(data: godzina, tempDzien: temp, opisDzien: opis))
                    }
                }
                // znajdz dni z tymi samymi datami
                let dupl = tempPozniej.reduce(into: [Date: [ModelPozniej]]()) {
                    $0[$1.data, default: []].append($1)
                }
                tempPozniej.removeAll(keepingCapacity: false)
                for item in dupl.values {
                    if (item.count == 2) {
                        var modelPozniej = ModelPozniej(data: item[0].data)
                        for part in item {
                            if let tempNoc = part.tempNoc, let opisNoc = part.opisNoc {
                                modelPozniej.tempNoc = tempNoc
                                modelPozniej.opisNoc = opisNoc
                            } else if let tempDzien = part.tempDzien, let opisDzien = part.opisDzien {
                                modelPozniej.tempDzien = tempDzien
                                modelPozniej.opisDzien = opisDzien
                            }
                        }
                        pozniej.append(modelPozniej)
                    } else {
                        pozniej.append(item[0])
                    }
                }
            }
        case .teraz:
//            let godzinawInt = json["dt"].intValue
//            let godzina = Date(timeIntervalSince1970: TimeInterval(godzinawInt))
            let temp = Temperatura(k: json["main"]["temp"].doubleValue)
            let opis = json["weather"][0]["description"].stringValue
//            let ciśnienie = json["main"]["pressure"].intValue
//            let wilgotność = json["main"]["humidity"].stringValue
//            let zachmurzenie = json["clouds"]["all"].stringValue
            let wiatr = json["wind"]["speed"].doubleValue
            let deszcz = json["rain"]["3h"].doubleValue
            dzisiaj = ModelDzisiaj(temp: temp, opis: opis, deszcz: deszcz, wiatr: wiatr)
        }
        refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    //odswiez, pokaz wskaznik ladowania
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        model = nil
        self.tableView.reloadData()
        proba = 0
        lokalizacja = nil
//        objArray.removeAll(keepingCapacity: false)
        self.navigationItem.title = "ładowanie..."
        performSelector(inBackground: #selector(sprawdzNazweMiasta), with: nil)
    }
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        self.refreshControl?.beginRefreshingManually()
    }
    
    
    
    //pokaz blad jak cos pojdzie nie tak
    @objc func showError() {
        let ac = UIAlertController(title: "Wystąpił błąd", message: "Nie udało się załadować danych. Spróbuj ponownie później.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    

}



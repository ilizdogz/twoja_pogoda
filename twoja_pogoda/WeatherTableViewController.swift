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

class WeatherTableViewController: UITableViewController, UITabBarControllerDelegate, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var location: CLLocation?
    
    var model: WeatherModel?
    var cityId: String?
    var foundLocation = false
    var getLocationCounter: Int = 0
    var storedOffset = [Int: CGFloat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //wyglad to wszystko
        navigationController?.navigationBar.barTintColor = Colors.blackAlpha
        //przewijanie do gory przez tabBar
        self.tabBarController?.delegate = self
    }
    struct PropertyKeys {
        static var hour = "hour"
        static var tempK = "tempK"
        static var desc = "desc"
        static var wind = "wind"
        static var rain = "rain"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.refreshControl?.beginRefreshingManually()
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        //kolory tutaj jakby ktos zmienil ustawienia i potem wrocil
        self.tableView.backgroundColor = savedColors.bg
        self.tableView.backgroundView?.backgroundColor = savedColors.bg
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
            return 2 + model!.later.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath) as! TodayTableViewCell
            let today = model!.today
            cell.tempLabel.text = "\(String(format: "%.2f", today.temp.returnFormat(tempUnit))) \(tempUnit.rawValue)"
            cell.descLabel.text = today.desc
            if let snow = today.snow {
                cell.rainLabel.text = "\(NSLocalizedString("snow", comment: "snow")): \(String(format: "%.2f", snow)) mm"
            } else {
                if (today.temp.c <= 0 && today.rain == 0) {
                    cell.rainLabel.text = "\(NSLocalizedString("snow", comment: "snow")): 0.00 mm"
                } else {
                    cell.rainLabel.text = "\(NSLocalizedString("rain", comment: "rain")): \(String(format: "%.2f", today.rain)) mm"
                }
            }
            cell.windLabel.text = "\(NSLocalizedString("wind", comment: "wind")): \(String(format: "%.2f", today.wind)) m/s"
            cell.setColors()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Next24hCell", for: indexPath) as! Next24hTableViewCell
            cell.backgroundColor = savedColors.bg
            cell.weatherView.backgroundColor = savedColors.bg
            cell.next24hLabel.textColor = savedColors.day
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaterCell", for: indexPath) as! LaterTableViewCell
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd/MM/yyyy"
            formatter.locale = Locale(identifier: Locale.current.identifier)
            let item = model!.later[indexPath.row - 2]
            cell.dateLabel.text = formatter.string(from: item.date).lowercased()
            if let tempDay = item.tempDay, let descDay = item.descDay {
                cell.dayTempLabel.text = "\(String(format: "%.2f", tempDay.returnFormat(tempUnit))) \(tempUnit.rawValue)"
                cell.dayDescLabel.text = descDay
            } else {
                cell.dayView.isHidden = true
            }
            if let tempNight = item.tempNight, let descNight = item.descNight {
                cell.nightTempLabel.text = "\(String(format: "%.2f", tempNight.returnFormat(tempUnit))) \(tempUnit.rawValue)"
                cell.nightDescLabel.text = descNight
            } else {
                cell.nightView.isHidden = true
            }
            cell.setColors()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            //today
            return 200
        case 1:
            //next 24h
            return 220
        default:
            //later
            return 210
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? Next24hTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? Next24hTableViewCell else { return }
        
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
    
    @objc func checkCityName() {
        if let id = cityId {
            getDataWithId(id: id, apiKey: apiKey, callback: { (data, err) in
                if err != nil {
                    self.showError()
                    self.refreshControl?.endRefreshing()
                } else {
                    self.model = data
                    self.navigationItem.title = self.model!.cityName
                    self.refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                    self.tableView.reloadData()
                }
            })
        } else {
            getLocation()
        }
    }
    
    //lokalizacja
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        getLocationCounter += 1
        makeUrl()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
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
    
    
    
    func makeUrl() {
        if let loc = location,
            getLocationCounter == 1 {
            getDataWithLocation(location: loc, apiKey: apiKey, callback: { (data, err) in
                if err != nil {
                    self.performSelector(onMainThread: #selector(self.showError), with: nil, waitUntilDone: false)
                    self.refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
                } else {
                    self.model = data
                    self.navigationItem.title = self.model!.cityName
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            })
        } else if getLocationCounter > 1 {
            // don't refresh again after finding location
            return
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: false)
        }
    }
    
    //odswiez, pokaz wskaznik ladowania
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        model = nil
        self.tableView.reloadData()
        getLocationCounter = 0
        location = nil
//        objArray.removeAll(keepingCapacity: false)
        self.navigationItem.title = NSLocalizedString("loading", comment: "loading")
        performSelector(inBackground: #selector(checkCityName), with: nil)
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



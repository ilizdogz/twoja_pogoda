//
//  TodayViewController.swift
//  weather_widget
//
//  Created by Krzysztof Glimos on 19.02.2018.
//  Copyright © 2018 Krzysztof Glimos. All rights reserved.
//

import UIKit
import NotificationCenter
import YourWeatherFramework
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    lazy var locationManager = CLLocationManager()
    var savedTempFormat: Stopien!
    var updateResult = NCUpdateResult.noData
        
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        locationManager.delegate = self
        cityNameLabel.text = "--"
        windLabel.text = "--"
        rainLabel.text = "--"
        tempLabel.text = "--"
        descLabel.text = "--"
        preferredContentSize = CGSize(width: self.view.frame.width, height: 110)
        let defaults = UserDefaults.standard
        if let tempRaw = defaults.object(forKey: "temperatura") as? String {
            savedTempFormat = Stopien(rawValue: tempRaw)
        } else {
            let tempFormat = Stopien.c
            defaults.set(tempFormat.rawValue, forKey: "temperatura")
            savedTempFormat = tempFormat
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            cityNameLabel.text = "--"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityNameLabel.text = "--"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getDataWithLocation(location: locations[0], apiKey: apiKey) { (data, err) in
            if err != nil {
                self.updateResult = .noData
            } else {
                self.cityNameLabel.text = data!.cityName
                self.tempLabel.text = "\(String(format: "%.2f", data!.dzisiaj.temp.returnFormat(self.savedTempFormat))) \(self.savedTempFormat.rawValue)"
                self.descLabel.text = data!.dzisiaj.opis
                if let snow = data!.dzisiaj.snieg {
                    self.rainLabel.text = "\(String(format: "%.2f", snow)) mm"
                } else {
                    self.rainLabel.text = "\(String(format: "%.2f", data!.dzisiaj.deszcz)) mm"
                }
                self.windLabel.text = "\(String(format: "%.2f", data!.dzisiaj.wiatr)) m/s"
                self.updateResult = .newData
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(updateResult)
    }
    
}

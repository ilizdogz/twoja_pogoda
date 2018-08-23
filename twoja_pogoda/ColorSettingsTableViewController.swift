//
//  UstawieniaPogodaTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 01.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class ColorSettingsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var tabPreview: UIView!
    @IBOutlet weak var rainPreview: UIButton!
    @IBOutlet weak var windPreview: UIButton!
    @IBOutlet var dayPreview: [UIButton]!
    @IBOutlet var tempPreview: [UIButton]!
    @IBOutlet var descPreview: [UIButton]!
    @IBOutlet var hourPreview: [UIButton]!
    @IBOutlet weak var savedPlacePreview: UIButton!
    @IBOutlet weak var savedTempPreview: UIButton!
    @IBOutlet weak var savedRainPreview: UIButton!
    @IBOutlet weak var changeBgColor: UIButton!

    var tempColors: SavedColors!
    
    //from ColorPickerVc to others
    var tempTag: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tabPreview.layer.cornerRadius = 8
        tempColors = savedColors
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //widok w karcie

    //zmien wyglad
    func updateView() {
        for item in dayPreview {
            item.setTitleColor(tempColors.day, for: .normal)
        }
        for item in tempPreview {
            item.setTitleColor(tempColors.temp, for: .normal)
        }
        for item in descPreview {
            item.setTitleColor(tempColors.desc, for: .normal)
        }
        for item in hourPreview {
            item.setTitleColor(tempColors.hour, for: .normal)
        }
        windPreview.setTitleColor(tempColors.wind, for: .normal)
        rainPreview.setTitleColor(tempColors.rain, for: .normal)
        savedPlacePreview.setTitleColor(tempColors.savedCity, for: .normal)
        savedTempPreview.setTitleColor(tempColors.temp, for: .normal)
        savedRainPreview.setTitleColor(tempColors.rain, for: .normal)
        changeBg(color: tempColors.bg)
    }
    
    //zapisywanie/wczytywanie
    
    func save() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: tempColors)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "savedColors")
        savedColors = tempColors
    }

    @IBAction func changeColor(_ sender: UIButton) {
        tempTag = sender.tag
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    func changeSaved(_ color: UIColor) {
        guard let tag = tempTag else { return }
        switch tag {
        case 1000:
            tempColors.day = color
        case 1001:
            tempColors.temp = color
        case 1002:
            tempColors.desc = color
        case 1003:
            tempColors.rain = color
        case 1004:
            tempColors.wind = color
        case 1005:
            tempColors.hour = color
        case 1006:
            tempColors.savedCity = color
        case 1007:
            tempColors.bg = color
        default:
            break
        }
        tempTag = nil
        updateView()
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
    func changeBg(color: UIColor) {
        tableView.backgroundColor = color
        let paths = [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2)]
        for path in paths {
            let cell = tableView.cellForRow(at: path)
            cell?.backgroundColor = color
        }
        tabPreview.backgroundColor = color
        if Colors.isDark(color) {
            changeBgColor.setTitleColor(UIColor.white, for: .normal)
            changeBgColor.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            changeBgColor.setTitleColor(Colors.navCont, for: .normal)
            savedPlacePreview.setTitleColor(Colors.navCont, for: .normal)
        }
    }

}

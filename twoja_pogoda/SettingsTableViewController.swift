//
//  UstawieniaTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 01.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit
import SafariServices
import YourWeatherFramework

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var customizeViewLabel: UILabel!
    @IBOutlet var unitButtons: [UIButton]!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var dataFromLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.navigationBar.barTintColor = Colors.blackAlpha
        
        let backButton = UIBarButtonItem(title: NSLocalizedString("back", comment: "back"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        for button in unitButtons {
            if button.titleLabel?.text == tempUnit.rawValue {
                button.isSelected = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeBg(color: savedColors.bg)
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
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func changeBg(color: UIColor) {
        tableView.backgroundColor = color
        if Colors.isDark(color) {
            tempLabel.textColor = UIColor.white
            customizeViewLabel.textColor = UIColor.white
        } else {
            tempLabel.textColor = Colors.navCont
            customizeViewLabel.textColor = Colors.navCont
        }
    }
    
    //zmien jednostke temperatury
    @IBAction func changeTemp(_ sender: UIButton) {
        for btn in unitButtons {
            btn.isSelected = false
        }
        sender.isSelected = true
        switch sender.titleLabel!.text! {
        case TempUnit.c.rawValue:
            tempUnit = TempUnit.c
        case TempUnit.f.rawValue:
            tempUnit = TempUnit.f
        case TempUnit.k.rawValue:
            tempUnit = TempUnit.k
        default:
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(tempUnit.rawValue, forKey: "temp")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 2 && indexPath.row == 1) {
            let url = URL(string: "https://openweathermap.org")
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true)
            
        }
    }
    

    //przywróć domyślne
    @IBAction func przywrocDomyslne(_ sender: UIButton) {
        let ac = UIAlertController(title: NSLocalizedString("are_you_sure", comment: "are_you_sure"), message: NSLocalizedString("restore_def", comment: "restore_def_msg"), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: NSLocalizedString("restore_def", comment: "restore_def"), style: .default) { [unowned self] (action: UIAlertAction)  in
            self.defaultSettings()
        })
        ac.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func defaultSettings() {
        let defaults = UserDefaults.standard
        let savedData = NSKeyedArchiver.archivedData(withRootObject: SavedColors.defaultSettings)
        defaults.set(savedData, forKey: "savedColors")
        savedColors = SavedColors.defaultSettings
        changeBg(color: savedColors!.bg)
        
    }

}

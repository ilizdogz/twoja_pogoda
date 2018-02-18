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

class UstawieniaTableViewController: UITableViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var widokMiejscaLabel: UILabel!
    @IBOutlet var przyciskiJedn: [UIButton]!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var dataFromLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        
        let backButton = UIBarButtonItem(title: NSLocalizedString("back", comment: "back"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        for button in przyciskiJedn {
            if button.titleLabel?.text == formatTemp.rawValue {
                button.isSelected = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        zmienTlo(kolor: zapisaneKolory.tlo)
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
    
    func zmienTlo(kolor: UIColor) {
        tableView.backgroundColor = kolor
        let czyCiemne = Kolory.ciemneCzyJasne(kolorTla: kolor)
        switch czyCiemne {
        case .jasne:
            tempLabel.textColor = Kolory.navCont
            widokMiejscaLabel.textColor = Kolory.navCont
        case .ciemne:
            tempLabel.textColor = Kolory.bialy
            widokMiejscaLabel.textColor = Kolory.bialy
        }
    }
    
    //zmien jednostke temperatury
    @IBAction func zmienTemp(_ sender: UIButton) {
        for przycisk in przyciskiJedn {
            przycisk.isSelected = false
        }
        sender.isSelected = true
        switch sender.titleLabel!.text! {
        case Stopien.c.rawValue:
            formatTemp = Stopien.c
        case Stopien.f.rawValue:
            formatTemp = Stopien.f
        case Stopien.k.rawValue:
            formatTemp = Stopien.k
        default:
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(formatTemp.rawValue, forKey: "temperatura")
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
            self.domyslneUstawienia()
        })
        ac.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func domyslneUstawienia() {
        let defaults = UserDefaults.standard
        let savedData = NSKeyedArchiver.archivedData(withRootObject: ZapisaneKolory.domyslneUstawienia)
        defaults.set(savedData, forKey: "zapisaneKolory")
        zmienTlo(kolor: ZapisaneKolory.domyslneUstawienia.tlo)
        zapisaneKolory = ZapisaneKolory.domyslneUstawienia
    }

}

//
//  UstawieniaTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 01.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class UstawieniaTableViewController: UITableViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var widokMiejscaLabel: UILabel!
    @IBOutlet var przyciskiJedn: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        
        let backButton = UIBarButtonItem(title: "wstecz", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Menlo", size: 15)!], for: .normal)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func zmienTlo(kolor: UIColor) {
        tableView.backgroundColor = kolor
        let tableCG = tableView.backgroundColor!.cgColor
        let jasnoscR = tableCG.components![0] * 0.299
        let jasnoscG = tableCG.components![1] * 0.587
        let jasnoscB = tableCG.components![2] * 0.114
        //czy przyciski powinny być jasne czy ciemne?
        let jasnoscTla = 1 - (jasnoscR + jasnoscG + jasnoscB)
        if jasnoscTla < 0.5 {
            //tło jest jasne - potrzebne są ciemne kolory
            tempLabel.textColor = Kolory.navCont
            widokMiejscaLabel.textColor = Kolory.navCont
        } else {
            //tło jest ciemne - portrzebne są jasne kolory
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
    

    //przywróć domyślne
    @IBAction func przywrocDomyslne(_ sender: UIButton) {
        let ac = UIAlertController(title: "Na pewno?", message: "Czy na pewno chcesz przywrócić domyślne?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Przywróć domyślne", style: .default) { [unowned self] (action: UIAlertAction)  in
            self.domyslneUstawienia()
        })
        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: nil))
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

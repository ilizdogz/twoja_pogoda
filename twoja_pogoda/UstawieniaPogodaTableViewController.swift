//
//  UstawieniaPogodaTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 01.09.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class UstawieniaPogodaTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var kartaPodglad: UIView!
    @IBOutlet weak var dzienPodglad: UIButton!
    @IBOutlet weak var godzinaPodglad: UIButton!
    @IBOutlet weak var tempPodglad: UIButton!
    @IBOutlet weak var opisPodglad: UIButton!
    @IBOutlet weak var cisnieniePodglad: UIButton!
    @IBOutlet weak var wilgotnoscPodglad: UIButton!
    @IBOutlet weak var zachmurzeniePodglad: UIButton!
    @IBOutlet weak var wiatrPodglad: UIButton!
    @IBOutlet weak var deszczPodglad: UIButton!
    @IBOutlet weak var zapisaneMiescePodglad: UIButton!
    @IBOutlet weak var zapisaneTempPodglad: UIButton!
    @IBOutlet weak var zapisaneDeszczPodglad: UIButton!
    @IBOutlet weak var zmienKolorTla: UIButton!

    var tempKolory: ZapisaneKolory!
    
    //z ColorPickerVC do zapisanych
    var tempTag: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.backgroundColor = Kolory.navCont
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        kartaPodglad.layer.cornerRadius = 8
        tempKolory = zapisaneKolory
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        zapisz()
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
            return 1
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
        dzienPodglad.setTitleColor(tempKolory.dzien, for: .normal)
        godzinaPodglad.setTitleColor(tempKolory.godzina, for: .normal)
        tempPodglad.setTitleColor(tempKolory.temp, for: .normal)
        opisPodglad.setTitleColor(tempKolory.opis, for: .normal)
        cisnieniePodglad.setTitleColor(tempKolory.cisnienie, for: .normal)
        wilgotnoscPodglad.setTitleColor(tempKolory.wilgotnosc, for: .normal)
        zachmurzeniePodglad.setTitleColor(tempKolory.zachmurzenie, for: .normal)
        wiatrPodglad.setTitleColor(tempKolory.wiatr, for: .normal)
        deszczPodglad.setTitleColor(tempKolory.deszcz, for: .normal)
        zapisaneMiescePodglad.setTitleColor(tempKolory.zapisaneMiejsce, for: .normal)
        zapisaneTempPodglad.setTitleColor(tempKolory.temp, for: .normal)
        zapisaneDeszczPodglad.setTitleColor(tempKolory.deszcz, for: .normal)
        zapisaneTempPodglad.setTitleColor(tempKolory.temp, for: .normal)
        zmienTlo(kolor: tempKolory.tlo)
    }
    
    //zapisywanie/wczytywanie
    
    func zapisz() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: tempKolory)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "zapisaneKolory")
        zapisaneKolory = tempKolory
    }

    @IBAction func zmienKolor(_ sender: UIButton) {
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
    
    func zmienZapisane(_ kolor: UIColor) {
        guard let tag = tempTag else { return }
        switch tag {
        case 1000:
            tempKolory.dzien = kolor
        case 1001:
            tempKolory.godzina = kolor
        case 1002:
            tempKolory.temp = kolor
        case 1003:
            tempKolory.opis = kolor
        case 1004:
            tempKolory.cisnienie = kolor
        case 1005:
            tempKolory.wilgotnosc = kolor
        case 1006:
            tempKolory.zachmurzenie = kolor
        case 1007:
            tempKolory.wiatr = kolor
        case 1008:
            tempKolory.deszcz = kolor
        case 1009:
            tempKolory.zapisaneMiejsce = kolor
        case 1010:
            tempKolory.deszcz = kolor
        case 1011:
            tempKolory.temp = kolor
        case 1012:
            tempKolory.tlo = kolor
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
    
    func zmienTlo(kolor: UIColor) {
        tableView.backgroundColor = kolor
        let paths = [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2)]
        for path in paths {
            let cell = tableView.cellForRow(at: path)
            cell?.backgroundColor = kolor
        }
        kartaPodglad.backgroundColor = kolor
        let tableCG = tableView.backgroundColor!.cgColor
        let jasnoscR = tableCG.components![0] * 0.299
        let jasnoscG = tableCG.components![1] * 0.587
        let jasnoscB = tableCG.components![2] * 0.114
        //czy przyciski powinny być jasne czy ciemne?
        let jasnoscTla = 1 - (jasnoscR + jasnoscG + jasnoscB)
        if jasnoscTla < 0.5 {
            //tło jest jasne - potrzebne są ciemne kolory
            zmienKolorTla.setTitleColor(Kolory.navCont, for: .normal)
            godzinaPodglad.backgroundColor = Kolory.czarnyPrzezr
            zapisaneMiescePodglad.setTitleColor(Kolory.navCont, for: .normal)
        } else {
            //tło jest ciemne - portrzebne są jasne kolory
            zmienKolorTla.setTitleColor(Kolory.bialy, for: .normal)
            godzinaPodglad.backgroundColor = Kolory.godzinaBG
            zapisaneMiescePodglad.setTitleColor(Kolory.bialy, for: .normal)
        }
    }

}

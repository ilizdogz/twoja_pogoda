//
//  WyszukajViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 31.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

//WIP WIP WIP
//do usuniecia jak tylko bedzie dzialac UITableController z UISearchController

import UIKit

class WyszukajViewController: UIViewController {

    @IBOutlet weak var wyszukajTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        // Do any additional setup after loading the view.
        
        let backButton = UIBarButtonItem(title: NSLocalizedString("back", comment: "back"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        //backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = zapisaneKolory.tlo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //wip wip wip
    //w planie usunac to wszystko w chuj i zmienic na TableController z wyszukiwaniem
    @IBAction func wyszukaj(_ sender: UITextField) {
        sender.endEditing(false)
        guard let text = sender.text else { return }
        let stack = CoreDataStack()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Pogoda") as? PogodaTableViewController {
            if let result = stack.loadSavedData(name: text) {
            //if let id = wczytajListy(name: text) {
                let id = result.first!.id!
                vc.idMiasta = id
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let ac = UIAlertController(title: NSLocalizedString("not_found_header", comment: "not_found_header"), message: NSLocalizedString("not_found_msg", comment: "not_found_msg"), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            //vc.idMiasta = sender.text
            
        }
    }
    
    //schowaj klawiature po dotknieciu ekranu
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //powrot jesli nie znajdzie miasta
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

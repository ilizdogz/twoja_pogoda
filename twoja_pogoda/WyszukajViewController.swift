//
//  WyszukajViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 31.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class WyszukajViewController: UIViewController {

    @IBOutlet weak var wyszukajTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        // Do any additional setup after loading the view.
        
        let backButton = UIBarButtonItem(title: "wstecz", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = zapisaneKolory.tlo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func wyszukaj(_ sender: UITextField) {
        sender.endEditing(false)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Pogoda") as? PogodaTableViewController {
            vc.miasto = sender.text
            navigationController?.pushViewController(vc, animated: true)
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

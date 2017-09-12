//
//  ZapisaneTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class ZapisaneTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var dodaj: UIBarButtonItem!
    @IBOutlet weak var edytuj: UIBarButtonItem!
    
    
    var zapisaneMiejsca = [String]()
    var pogoda = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //wyglad to wszystko
        
        
        //self.tableView.backgroundColor = Kolory.navCont
        dodaj.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Menlo", size: 15)!], for: .normal)
        edytuj.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Menlo", size: 15)!], for: .normal)
        
        //do przewijania do gory przez tabBar
        self.tabBarController?.delegate = self
        
        let backButton = UIBarButtonItem(title: "wstecz", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Menlo", size: 15)!], for: .normal)
        navigationItem.backBarButtonItem = backButton
        
        //wczytywanie/zapisywanie
        wczytajMiejsca()
        navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        self.zapisz()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //uruchom odswiezanie UIRefreshControl - z extension
        refreshControl?.beginRefreshingManually()
        //odswiez przy ponownym otwarciu
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        self.tableView.backgroundColor = zapisaneKolory.tlo
        /*
        let czyCiemne = Kolory.ciemneCzyJasne(kolorTla: zapisaneKolory.tlo)
        switch czyCiemne {
        case .ciemne:
        */
            //navigationController?.navigationBar.barTintColor = Kolory.czarnyPrzezr
        
        /*
        case .jasne:
            navigationController?.navigationBar.barTintColor = Kolory.bialy
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Kolory.czarnyPrzezr, NSFontAttributeName: UIFont(name: "Menlo", size: 15)!]
            navigationController?.navigationBar.barStyle = UIBarStyle.black
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
        if section == 0 {
            return pogoda.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miejsce", for: indexPath) as! MiejsceTableViewCell
        let pogodaW = pogoda[indexPath.row]
        let temperatura = pogodaW["temp"] as! Temperatura
        // Configure the cell...
        cell.wypelnij(miejsce: pogodaW["miasto"] as! String, temp: temperatura.returnFormat(), deszcz: pogodaW["deszcz"]as! Double)
        cell.zmienKolory(kolory: zapisaneKolory)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Pogoda") as? PogodaTableViewController {
            vc.miasto = zapisaneMiejsca[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        /*
        let vc = PogodaTableViewController()
        let wybraneMiasto = zapisaneMiejsca[indexPath.row]
        vc.miasto = wybraneMiasto
        */
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    //pozwala na usuwanie
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            zapisaneMiejsca.remove(at: indexPath.row)
            pogoda.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.zapisz()
        }
    }
    

    //dodawanie miejsca po wybraniu dodaj
    @IBAction func dodajMiejsce(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "dodaj miejsce", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "wyślij", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            if answer.text != "" {
                self.submit(miasto: answer.text!)
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    
    func submit(miasto: String) {
        let lowerMiasto = miasto.lowercased()
        zapisaneMiejsca.append(lowerMiasto)
        
        let indexPath = IndexPath(row: pogoda.count, section: 0)
        fetchJSONMiasta(adres: lowerMiasto)
        tableView.insertRows(at: [indexPath], with: .automatic)
        self.zapisz()
    }
    
    //edytowanie miejsca po wybraniu edytuj
    @IBAction func edytujMiasta(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    //zmien miejsce na liscie
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let przeniesioneMiasto = zapisaneMiejsca.remove(at: sourceIndexPath.row)
        let przeniesionaPogoda = pogoda.remove(at: sourceIndexPath.row)
        zapisaneMiejsca.insert(przeniesioneMiasto, at: destinationIndexPath.row)
        pogoda.insert(przeniesionaPogoda, at: destinationIndexPath.row)
        tableView.reloadData()
        self.zapisz()
    }
    
    //przewin do gory przez przycisk w UITabBar
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    //zaladuj/wczytaj zapisane miejsca
    func zapisz() {
        let defaults = UserDefaults.standard
        defaults.set(zapisaneMiejsca, forKey: "zapisaneMiejsca")
    }
    
    func wczytajMiejsca() {
        let defaults = UserDefaults.standard
        zapisaneMiejsca = defaults.object(forKey: "zapisaneMiejsca") as? [String] ?? ["Jaworzno", "Warszawa", "Kraków", "New York"]
    }
    
    //zaladuj pogode z zapisaneMiejsca
    
    func zaladujPogode() {
        for miejsce in zapisaneMiejsca {
            fetchJSONMiasta(adres: miejsce)
        }
    }
    func fetchJSONMiasta(adres: String) {
        var adresLower = adres.lowercased()
        adresLower = adresLower.replacingOccurrences(of: " ", with: "-")
        adresLower = adresLower.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let adresMiasta = "https://api.openweathermap.org/data/2.5/weather?q=\(adresLower)&appid=94b98d6c81d5bf988f14280a4ee67236&lang=pl"
        if let url = URL(string: adresMiasta) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["cod"] == 200 {
                    self.parse(json: json)
                } else {
                    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                    refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)

                }
            } else {
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)

            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)


        }
    }
    
    
    func parse(json: JSON) {
        var miasto = json["name"].stringValue
        miasto += ", "
        miasto += json["sys"]["country"].stringValue
        miasto = miasto.lowercased()
        let temp = Temperatura(k:json["main"]["temp"].doubleValue)
        let deszcz = json["rain"]["3h"].doubleValue
        let obj = ["miasto": miasto, "temp": temp, "deszcz": deszcz] as [String : Any]
        pogoda.append(obj)
        DispatchQueue.main.async { [unowned self] in
            self.navigationItem.title = "zapisane miejsca"
        }
        refreshControl?.performSelector(onMainThread: #selector(UIRefreshControl.endRefreshing), with: nil, waitUntilDone: true)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Wystąpił błąd", message: "Nie udało się załadować danych. Spróbuj ponownie później.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    //odśwież
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        let miejsca: [String] = zapisaneMiejsca
        zapisaneMiejsca.removeAll(keepingCapacity: false)
        pogoda.removeAll(keepingCapacity: false)
        zapisaneMiejsca.removeAll(keepingCapacity: false)
        tableView.reloadData()
        zapisaneMiejsca = miejsca
        self.navigationItem.title = "ładowanie..."
        performSelector(inBackground: #selector(zaladujPogode), with: nil)
    }
    
    func applicationDidBecomeActive(_ notification: NSNotification) {
        refreshControl?.beginRefreshingManually()
    }
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        guard segue.identifier == "pokazZapisane" else { return }
        let destination = segue.destination as! PogodaTableViewController
        let indexPath = tableView.indexPathForSelectedRow
        // Pass the selected object to the new view controller.
        destination.miasto = zapisaneMiejsca[indexPath!.row]
    }
    */
   

}

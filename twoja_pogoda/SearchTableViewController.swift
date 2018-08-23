//
//  WyszukajTableViewController.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 02.11.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentSearchForText(searchController.searchBar.text!)
    }
    

    var nameArray = [String]()
    var idArray = [String]()
    var isAdding = false
    var selectedId: String?
    
    let searchController = UISearchController(searchResultsController: nil)
    //let searchFooter = SearchFooter()
    //@IBOutlet var searchFooter: SearchFooter!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = savedColors.bg
        self.tableView.backgroundView?.backgroundColor = savedColors.bg
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.navigationBar.barTintColor = Colors.blackAlpha
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "wyszukaj miasto"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.barStyle = UIBarStyle.black
        //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        //searchController.searchBar.isFocused = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        //tableView.tableFooterView = searchFooter
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentSearchForText(_ searchText: String, scope: String = "All") {
        /*nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)*/
        let stack = CoreDataStack()
        let array = stack.searchForIds(input: searchText)
        if (array != nil && !searchText.isEmpty) {
            var size: Int {
                if (array!.count) > 20 {
                    return 20
                } else {
                    return array!.count
                }
            }
            var tempIdArray = [String]()
            var tempNameArray = [String]()
            for i in 0 ..< size {
                let id = array![i].id!
                let name = "\(array![i].name!), \(array![i].country!)"
                if (!tempNameArray.contains(name)) {
                    tempIdArray.append(id)
                    tempNameArray.append(name)
                }
            }
            idArray = tempIdArray
            nameArray = tempNameArray
        } else {
            idArray = [String]()
            nameArray = [String]()
        }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row > 0) {
            if (isAdding) {
                //schowaj przycisk anuluj, bo inaczej bedzie go widac caly czas
                searchController.searchBar.setShowsCancelButton(false, animated: false)
                searchController.dismiss(animated: false, completion: {[unowned self] in
                    self.selectedId = self.idArray[indexPath.row - 1]
                    self.performSegue(withIdentifier: "unwindToSaved", sender: self)
                    //navigationController?.popViewController(animated: true)
                })
            } else {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "Weather") as? WeatherTableViewController else { return }
                vc.cityId = idArray[indexPath.row - 1]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
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
        /*
        if (nameArray.count > 0) {
            navigationItem.prompt = "Znaleziono \(nameArray.count)"
        } else if (!searchBarIsEmpty()){
            navigationItem.prompt = "Nie znaleziono"
        } else {
            navigationItem.prompt = nil
        }
        */
        if (!searchBarIsEmpty()) {
            return nameArray.count + 1
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        // Configure the cell...
        if (indexPath.row > 0) {
            cell.textLabel?.text = nameArray[indexPath.row - 1]
        } else {
            if (nameArray.count > 0) {
                cell.textLabel?.text = "Znaleziono \(nameArray.count)"
            } else {
                cell.textLabel?.text = "Nie znaleziono"
            }
            cell.textLabel?.textColor = UIColor.white
            cell.accessoryType = .none
            cell.backgroundColor = Colors.navCont
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/*extension WyszukajTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentSearchForText(searchController.searchBar.text!)
    }
}*/

//
//  CountryTableViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 24/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit
import Foundation

class CountryTableViewController: UITableViewController {
    
    var items: [CountryResponse] = []
    var itemsFiltered: [CountryResponse] = []
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background")!)
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.definesPresentationContext = true
        
        self.tableView.reloadData()
        
        GetService.countryList(email: auth.tokenType.rawValue, password: auth.tokenValue) { (response:[CountryResponse]) in
            self.load(items: response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if items.count > 0 {
            TableViewHelper.showBackground(viewController: self)
            return 1
        } else {
            TableViewHelper.showEmptyMessage(saying: "Loading countries...", viewController: self)
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchController.isActive ? itemsFiltered.count : items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = getCountry(from: indexPath)
        if let label = cell.textLabel {
            label.text = country.name
            label.backgroundColor = UIColor.clear
            label.font = Fonts.NORMAL
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goto_web", sender: self)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        itemsFiltered = items.filter { item in
            return item.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! WebViewController
            let relativeUrl = getRelativeUrl(from: indexPath)
            controller.url = UrlBuilder.buildUrl(from: relativeUrl)
        }
    }
    
    func getRelativeUrl(from indexPath:IndexPath) -> String {
        let country = getCountry(from: indexPath)
        return "/c/" + country.code_iso
    }
    
    func getCountry(from indexPath:IndexPath) -> CountryResponse {
        return resultSearchController.isActive && resultSearchController.searchBar.text != "" ? itemsFiltered[indexPath.row] : items[indexPath.row]
    }
    
    func load(items: [CountryResponse]) {
        self.items = items
        self.itemsFiltered = items
        self.tableView.reloadData()
    }

}

extension CountryTableViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

//
//  CoproductionTreatyTableViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 24/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit
import Foundation

class CoproductionTreatyTableViewController: UITableViewController {
    var items: [CoproductionTreatyResponse] = []
    var itemsFiltered: [CoproductionTreatyResponse] = []
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
        
        GetService.coproductionTreatyList(email: auth.tokenType.rawValue, password: auth.tokenValue) { (response:[CoproductionTreatyResponse]) in
            self.load(items: response)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchController.isActive && resultSearchController.searchBar.text != "" ? itemsFiltered.count : items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoproductionTreatyTableViewCell
        cell.treaty = getTreaty(from: indexPath)
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goto_web", sender: self)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        itemsFiltered = items.filter { item in
            return item.countries_list.lowercased().contains(searchText.lowercased())
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
        let treaty = getTreaty(from: indexPath)
        return treaty.url
    }
    
    func getTreaty(from indexPath:IndexPath) -> CoproductionTreatyResponse {
        return resultSearchController.isActive && resultSearchController.searchBar.text != "" ? itemsFiltered[indexPath.row] : items[indexPath.row]
    }
    
    func load(items: [CoproductionTreatyResponse]) {
        self.items = items
        self.itemsFiltered = items
        self.tableView.reloadData()
    }
    
}

extension CoproductionTreatyTableViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

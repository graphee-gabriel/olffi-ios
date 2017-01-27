//
//  SearchTableViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 23/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var items: [SearchResultHit] = []
    var resultSearchController = UISearchController()
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background")!)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            let searchBar = controller.searchBar
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            searchBar.sizeToFit()
            let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
            searchTextField?.placeholder = "Search for a program..."
            
            self.tableView.tableHeaderView = searchBar
            
            return controller
        })()
        
        self.definesPresentationContext = true
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if items.count > 0 {
            TableViewHelper.showBackground(viewController: self)
            return 1
        } else {
            TableViewHelper.showEmptyMessage(saying: "Search for a program, fund or country...", viewController: self)
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.hit = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goto_web", sender: self)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let query:String = searchController.searchBar.text!
        if query.characters.count > 1 {
            search(for: query)
        } else {
            items = [SearchResultHit]()
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let hit = self.items[indexPath.row]
            let controller = segue.destination as! WebViewController
            controller.url = UrlBuilder.buildUrl(from: hit.program_url)
            controller.titleCustom = hit.program_name
        }
    }
    
    func search(for query:String) {
        self.query = query
        AlgoliaSearchManager().search(for: query, completionHandler: { (content, error) -> Void in
            if error == nil {
                //print("Result: \(content)")
                let response = Mapper<SearchResultResponse>().map(JSONObject: content)
                //print("Response contains \(response?.hits!.count) hits")
                if let res = response, let query = res.query {
                    if query == self.query {
                        if let hits = res.hits {
                            self.load(items: hits)
                        }
                    }
                }
            }
        })
    }
    
    func load(items: [SearchResultHit]) {
        self.items = items
        self.tableView.reloadData()
    }
}

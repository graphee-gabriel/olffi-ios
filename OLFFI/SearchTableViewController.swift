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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! //as UITableViewCell
        
        let hit = items[indexPath.row];
        cell.textLabel?.text = hit.program_name + " (\(hit.country_name!))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = self.items[indexPath.row]
        print("You clicked on \(hit.program_name!)")
        //let nav = AppNavigator(from: self)
        //nav.startWebApp(at: UrlBuilder.buildUrl(from: hit.program_url))
        print("segueee")
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
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

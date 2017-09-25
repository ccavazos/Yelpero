//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate, FiltersViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    
    let defaultSearchTerm = "Restaurants"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 104
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
     
        fetchDefaultRestaurants()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetch Functions
    
    func fetchDefaultRestaurants() {
        searchBar.text = defaultSearchTerm
        Business.searchWithTerm(term: defaultSearchTerm, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }
    
    func fetchData() {
        Business.searchWithTerm(term: searchBar.text!, sort: YelpSortMode.distance, categories: nil, deals: false) { (businessResults: [Business]!, error: Error!) in
            self.businesses = businessResults
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TableView DataSource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = self.businesses[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if searchBar.text == nil || searchBar.text == "" {
            // Do a default search for restaurants
            searchBar.text = defaultSearchTerm
        }
        fetchData()
    }
    
    // MARK: - FiltersViewController Delegate
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters: [String : AnyObject]) {
        
        // TODO: Update the filters
        
        fetchData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
}

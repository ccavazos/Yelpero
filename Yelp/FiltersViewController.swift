//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Cesar Cavazos on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    @IBOutlet var tableView: UITableView!

    weak var delegate: FiltersViewControllerDelegate?
    
    var filters: [[String: Any]] = [
        [
            "section" : "",
            "type" : "SwitchCell",
            "cells" : YelpConstants.deals
        ],
        [
            "section" : "Distance",
            "type" : "CheckboxCell",
            "cells" : YelpConstants.distance,
            "isCollapsed" : true
        ],
        [
            "section" : "Sort By",
            "type" : "CheckboxCell",
            "cells" : YelpConstants.sortBy,
            "isCollapsed" : true
        ],
        [
            "section" : "Categories",
            "type" : "SwitchCell",
            "cells" : YelpConstants.categories,
            "isCollapsed" : true
        ],
    ]
    
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 45
    
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSearchButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        let filters = [String: AnyObject]()
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView DataSource/Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = filters[section]["section"] as! String
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = filters[section]["cells"] as! [Dictionary<String, Any>]
        let cellType = filters[section]["type"] as! String
        if (cellType == "SwitchCell") {
            return rows.count
        } else if (cellType == "CheckboxCell") {
            let isCollapsed = filters[section]["isCollapsed"] as! Bool
            if isCollapsed == true {
                // We only need to show the selected value
                return 1
            } else {
                // Show all the values
                return rows.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = filters[indexPath.section]["type"] as! String
        let rows = filters[indexPath.section]["cells"] as! [Dictionary<String, Any>]
        let currentRow = rows[indexPath.row]
        
        if cellType == "SwitchCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = currentRow["name"] as? String
            cell.delegate = self
            
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            
            return cell
        } else if cellType == "CheckboxCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! CheckboxCell
            
            let isCollapsed = filters[indexPath.section]["isCollapsed"] as! Bool
            
            if isCollapsed == true {
                // We only need to show the selected value
                // TODO: Show the right value
                cell.checkboxLabel.text = currentRow["name"] as? String
            } else {
                // Show all the values
                cell.checkboxLabel.text = currentRow["name"] as? String
            }
            
//            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var filter = filters[indexPath.section]
        if let isCollapsed = filter["isCollapsed"] as? Bool {
            print("collapsed does not exist")
            print(isCollapsed)
        } else {
            print("collapsed does not exist")
        }
    }
    
    // MARK: - SwitchCell Delegate
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }

}

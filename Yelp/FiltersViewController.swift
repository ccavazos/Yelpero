//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Cesar Cavazos on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters: [Any])
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
//            "isCollapsed" : true
        ],
    ]
    
    var selectedFilters: [Any] = [
        false,
        0,
        0,
        [String]()
    ]
    
    var switchStates = [Int:[Int:Bool]]()
    var checkboxStates = [Int:[Int:Int]]()
    
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
        // Updates the deals option
        selectedFilters[0] = switchStates[0]?[0] ?? false
        // Updates the cateogory
        
        var selectedCategories = [String]()
        if let categoriesSwitches = switchStates[3] {
            for (row, isSelected) in categoriesSwitches {
                if (isSelected) {
                    selectedCategories.append(YelpConstants.categories[row]["code"]!)
                }
            }
        }

        selectedFilters[3] = selectedCategories;
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: selectedFilters)
    }
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView DataSource/Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cellType = filters[indexPath.section]["type"] as! String
        if cellType == "SwitchCell" {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = filters[section]["section"] as! String
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = filters[section]["cells"] as! [Dictionary<String, Any>]
        let cellType = filters[section]["type"] as! String
        if (cellType == "SwitchCell") {
            if let isCollapsed = filters[section]["isCollapsed"] as? Bool {
                print("Is Collapsed \(isCollapsed)")
                // TODO: Implement this
//                if isCollapsed && rows.count > 5 {
//                    return 5
//                } else {
//                    return rows.count
//                }
                return rows.count
            } else {
                return rows.count
            }
            
        } else if (cellType == "CheckboxCell") {
            let isCollapsed = filters[section]["isCollapsed"] as! Bool
            if isCollapsed == true {
                // We only need to show the selected value
                return 1
            } else {
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
            
            if switchStates[indexPath.section] != nil {
                cell.onSwitch.isOn = switchStates[indexPath.section]![indexPath.row] ?? false
            } else {
                cell.onSwitch.isOn = false
            }
            
            return cell
        } else if cellType == "CheckboxCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! CheckboxCell
            
            let isCollapsed = filters[indexPath.section]["isCollapsed"] as! Bool
            
            if isCollapsed == true {
                var selectedRow = rows.first(where: { $0["code"] as! Int == selectedFilters[indexPath.section] as! Int } )
                cell.checkboxLabel.text = selectedRow?["name"] as? String
                cell.checkboxImageView.image = UIImage(named: "Dropdown")
                cell.checkboxImageView.isHidden = false
            } else {
                // Show all the values
                cell.checkboxLabel.text = currentRow["name"] as? String
                cell.checkboxImageView.image = UIImage(named: "Radio")
                if currentRow["code"] as! Int == selectedFilters[indexPath.section] as! Int {
                    cell.checkboxImageView.isHidden = false
                } else {
                    cell.checkboxImageView.isHidden = true
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var filter = filters[indexPath.section]
        if let isCollapsed = filter["isCollapsed"] as? Bool {
            if isCollapsed {
                // We should open it
                filters[indexPath.section]["isCollapsed"] = false
            } else {
                // We should update the value and close it
                if checkboxStates[indexPath.section] == nil {
                    checkboxStates[indexPath.section] = [Int:Int]()
                }
                let rows = filters[indexPath.section]["cells"] as! [Dictionary<String, Any>]
                let currentRow = rows[indexPath.row]
                checkboxStates[indexPath.section]![indexPath.row] = currentRow["code"] as? Int
                selectedFilters[indexPath.section] = currentRow["code"] as? Int
                filters[indexPath.section]["isCollapsed"] = true
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - SwitchCell Delegate
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        if switchStates[indexPath.section] == nil {
            switchStates[indexPath.section] = [Int:Bool]()
        }
        switchStates[indexPath.section]![indexPath.row] = value
    }

}

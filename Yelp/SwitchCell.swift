//
//  SwitchCell.swift
//  Yelp
//
//  Created by Cesar Cavazos on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet var onSwitch: UISwitch!
    @IBOutlet var switchLabel: UILabel!

    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

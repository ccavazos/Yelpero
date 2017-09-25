//
//  CheckboxCell.swift
//  Yelp
//
//  Created by Cesar Cavazos on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CheckboxCell: UITableViewCell {

    @IBOutlet var checkboxLabel: UILabel!
    @IBOutlet var checkboxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

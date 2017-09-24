//
//  BusinessCell.swift
//  Yelp
//
//  Created by Cesar Cavazos on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var reviewsCountLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            if let url = business.imageURL {
                thumbImageView.setImageWith(url)
            }
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            if let url = business.ratingImageURL {
                ratingImageView.setImageWith(url)
            }
            
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 2.0
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

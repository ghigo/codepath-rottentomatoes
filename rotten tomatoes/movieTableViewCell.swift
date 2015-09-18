//
//  movieTableViewCell.swift
//  rotten tomatoes
//
//  Created by Marco Sgrignuoli on 9/17/15.
//  Copyright © 2015 Optimizely. All rights reserved.
//

import UIKit

class movieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

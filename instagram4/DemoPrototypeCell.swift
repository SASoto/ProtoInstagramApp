//
//  DemoPrototypeCell.swift
//  instagram4
//
//  Created by Saul Soto on 1/23/16.
//  Copyright © 2016 CodePath - Saul Soto. All rights reserved.
//

import UIKit
import AFNetworking

class DemoPrototypeCell: UITableViewCell {

    @IBOutlet weak var instaPhoto: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

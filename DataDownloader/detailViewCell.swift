//
//  detailViewCell.swift
//  DataDownloader
//
//  Created by Student on 4/8/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class detailViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var eventImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CustomeRequestTableViewCell.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/15/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class CustomeRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var medicine_name: UILabel!
    @IBOutlet weak var volunteer_name: UILabel!
    @IBOutlet weak var statusImage: UIImageView!{
        didSet{
            if DeviceInfo.DEVICE_TYPE == "iPad"{
                self.statusImage.contentMode = .center
            }

        }
    }

    @IBOutlet weak var lblTimeAgo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

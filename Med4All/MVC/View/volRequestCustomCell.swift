//
//  volRequestCustomCell.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/23/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class volRequestCustomCell: UITableViewCell {

    @IBOutlet weak var btn_favourit: UIButton!
    @IBOutlet weak var lbl_medcine_name: UILabel!
    @IBOutlet weak var lbl_donator_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var btn_willGo: UIButton!

    @IBOutlet weak var lblTimeAgo: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         btn_willGo.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

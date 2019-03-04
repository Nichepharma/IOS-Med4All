//
//  CustomArchiveCell.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/23/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class CustomArchiveCell: UITableViewCell {

    @IBOutlet weak var archive_lbl_title_name: UILabel!
    @IBOutlet weak var archive_medName: UILabel!
    @IBOutlet weak var archive_btn_finishRequest: UIButton!
    @IBOutlet weak var archive_img_requestStatus: UIImageView!
    
    
    // label title (اسم المتبرع)
    @IBOutlet weak var archive_volunteerName: UILabel!
    // label title (اسم الدواء)
    @IBOutlet weak var archive_lbl_title_medName: UILabel!

    @IBOutlet weak var lblTimeAgo: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if StaticVar.userTypeID == 2 {
            self.archive_lbl_title_name.text = "أسم المتبرع"
            self.archive_img_requestStatus.isHidden = true
            self.archive_btn_finishRequest.layer.cornerRadius = 15
            
        }else{
            self.archive_btn_finishRequest.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }

}

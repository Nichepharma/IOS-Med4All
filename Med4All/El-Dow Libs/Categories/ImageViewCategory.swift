//
//  ImageView.swift
//  MyBlood
//
//  Created by Yahia El-Dow on 12/4/16.
//  Copyright © 2016 Yahia El-Dow. All rights reserved.
//

import UIKit


extension UIImageView {

    func setRounded() {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor

    }

    func setRightButtom(){
        let imageWidth = self.frame.size.width
        let imageHeight = self.frame.size.height
        self.frame.origin = CGPoint(x: VarConfig.screenSize.width  - imageWidth,
                                    y: VarConfig.screenSize.height - imageHeight )
    }



    
}

//
//  NetCheck.swift
//  Med4All
//
//  Created by Yahia El-Dow on 9/24/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

import Foundation
import UIKit

class NetCheck : NSObject {

    private var  noInternetNoifiylabel = UILabel(){
        didSet{

        }
    }

    override init() {
        super.init()
        let  noInternetNoifiylabel = UILabel()
        noInternetNoifiylabel.text = "No Internet Connection ."
        noInternetNoifiylabel.textColor = .white
        self.noInternetNoifiylabel.frame.size.width = (UIScreen.screens.first?.bounds.size.width)!
        self.noInternetNoifiylabel.frame.size.height = (UIScreen.screens.first?.bounds.size.height)!  / 15
        self.noInternetNoifiylabel.frame.origin.x = 0
        self.noInternetNoifiylabel.frame.origin.y = 0
        let colors = [UIColor.red.cgColor ,  UIColor.yellow.cgColor]
        self.noInternetNoifiylabel.setGradienBackground(colors: colors)

    }




}

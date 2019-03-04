//
//  CustomTabBarItem.swift
//  AlfSalama
//
//  Created by Yahia El-Dow on 1/29/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class CustomTabBarItem: UITabBarItem {


    init(itemTitle : String , itemStrImage : String , itemTag : Int = 0 ){
        super.init()
        if let buttonImage =  UIImage(named: itemStrImage){
            self.title = itemTitle
            self.image = buttonImage
            self.tag = itemTag
            
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    
}

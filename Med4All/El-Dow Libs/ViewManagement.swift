//
//  ViewManagement.swift
//  AlfSalama
//
//  Created by Yahia El-Dow on 1/24/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class ViewManagement: NSObject {

    class func instanceFromNib(nibName : String) -> UIView {
        if let xibView =  Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView{
            return xibView
        }
//        let myPopupView = Bundle.main.loadNibNamed("NibView", owner: self, options: nil)?[0] as! UIView

        return UIView()
    }

}

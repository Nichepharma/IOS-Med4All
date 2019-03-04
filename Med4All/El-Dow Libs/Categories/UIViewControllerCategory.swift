//
//  UIViewControllerCategory.swift
//  Med4All
//
//  Created by Yahia El-Dow on 9/24/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {

    static func root () -> UIViewController {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            var topController =  vc
            while (topController.presentedViewController != nil) {
                topController = topController.presentedViewController!
            }
            return topController
        }

        return UIViewController()
    }


}

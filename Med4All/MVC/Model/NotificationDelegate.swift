//
//  NotificationDelegate.swift
//  Med4All
//
//  Created by Yahia El-Dow on 9/19/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

import UIKit
protocol NotificationDelegate {
    func didRecivedNotification()
}

class NotificationClass {
   static var delegate : NotificationDelegate!

}

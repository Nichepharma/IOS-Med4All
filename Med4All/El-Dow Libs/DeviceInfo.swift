//
//  DeviceConfiguration.swift
//  EstateRus
//
//  Created by Yahia El-Dow on 5/18/17.
//  Copyright © 2017 Production Code. All rights reserved.
//

import UIKit

class DeviceInfo {
    
    static var SCREEN_FRAME : CGRect {
        get{
            return (UIScreen.screens.first?.bounds)!
        }
    }
    
    static var SCREEN_WIDTH : CGFloat {
        get{
            return (UIScreen.screens.first?.bounds.size.width)!
        }
    }
    
    static var SCREEN_HEIGHT : CGFloat {
        get{
            return  (UIScreen.screens.first?.bounds.size.height)!
        }
    }
    
   static var DEVICE_TYPE : String {
        get{
            return UIDevice.current.model
        }
    
    }
    
    static var IOS_VERSTION : String {
        get{
            return UIDevice.current.systemVersion
        }
        
    }
    
    static var IOS_VERSTION2 : String {
        get{
            return UIDevice.current.name
        }
        
    }
}

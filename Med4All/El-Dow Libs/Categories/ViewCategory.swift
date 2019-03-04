//
//  ViewCategory.swift
//  Med4All
//
//  Created by Yahia El-Dow on 9/24/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

import Foundation
import UIKit


extension UIView{


    func setGradienBackground(colors : [CGColor] ,
                              location : [NSNumber] = [0.0 , 1.0] ,
                              startLocation : CGPoint = CGPoint(x: 1.0, y: 1.0)     ,
                              endLocation : CGPoint = CGPoint(x: 0, y: 0)  ){

        let gradienLayer = CAGradientLayer()
        gradienLayer.frame = self.frame
        gradienLayer.colors =  colors
        gradienLayer.locations = location
        gradienLayer.startPoint = startLocation
        gradienLayer.endPoint = endLocation

        self.layer.insertSublayer(gradienLayer, at: 0)
    }
}

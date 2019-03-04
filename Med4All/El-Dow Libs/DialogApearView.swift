//
//  DialogApearView.swift
//  EstateRus
//
//  Created by Yahia El-Dow on 11/2/17.
//  Copyright © 2017 Production Code. All rights reserved.
//

import UIKit

class DialogApearView: NSObject {
    fileprivate static var dialogView = UIView()
    
    static func show (messageApear : String ) {
        dialogView = UIView()
        self.dialogView.frame.size.width = DeviceInfo.SCREEN_WIDTH - (DeviceInfo.SCREEN_WIDTH * 0.1)
        self.dialogView.frame.size.height = DeviceInfo.SCREEN_HEIGHT / 9.5
        self.dialogView.center.x = (DeviceInfo.SCREEN_WIDTH / 2)
        self.dialogView.center.y = (DeviceInfo.SCREEN_HEIGHT / 2)
        self.dialogView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.dialogView.addSubview(self.prepareLabel(title: messageApear))
        self.dialogView.alpha = 0
        UIViewController.root().view.addSubview(self.dialogView)
    
        UIView.animate(withDuration: 0.5 , delay: 0 , animations: {
            self.dialogView.alpha = 1
            Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(removeDialog), userInfo: nil, repeats: false)
        })
        
    }
    
    
    private static func prepareLabel (title : String) -> UILabel{
        let lbl = UILabel()
        lbl.text = title

        lbl.frame.size.height = self.dialogView.frame.height
        lbl.frame.size.width = self.dialogView.frame.width
        lbl.textAlignment  = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        return lbl
    }
    
    @objc private static func removeDialog(){
        UIView.animate(withDuration: 0.2 , delay: 0 , animations: {
            
            for views in self.dialogView.subviews {
                if let lbl = views as? UILabel {
                    lbl.text = ""
                    lbl.frame.origin.x =  (self.dialogView.frame.size.width / 2)
                    lbl.frame.size = CGSize(width: 0, height: 0)
                    lbl.removeFromSuperview()
                }
            }
            self.dialogView.frame.origin.x =  (self.dialogView.frame.size.width / 2)
            self.dialogView.frame.size = CGSize(width: 0, height: 0)
        } , completion: {
            res in
            self.dialogView.removeFromSuperview()

            
        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

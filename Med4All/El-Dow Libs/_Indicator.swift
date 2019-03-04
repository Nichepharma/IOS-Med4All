//
//  _Indicator.swift
//  FirstSwiftApp
//
//  Created by Yahia on 8/3/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

import UIKit

class _Indicator: UIView {
    
        init() {
            let screenSize: CGRect = UIScreen.main.bounds
            let _View__IndicatorW : CGFloat =  screenSize.width
            let _View__IndicatorH : CGFloat = screenSize.height
            super.init(frame: CGRect(x: 0, y: 0, width: _View__IndicatorW, height:_View__IndicatorH))

            self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)

            let loadingView : UIView = UIView()
                loadingView.frame = CGRect(x: 0, y: 0, width: 100, height:100)
                loadingView.center = self.center
            //UIColorFromHex(0x444444, alpha: 0.7)
                loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                loadingView.clipsToBounds = true
                loadingView.layer.cornerRadius = 10
            self.addSubview(loadingView)


            let spinner___ : UIActivityIndicatorView = UIActivityIndicatorView()
                spinner___.activityIndicatorViewStyle  =  UIActivityIndicatorViewStyle.whiteLarge
                spinner___.hidesWhenStopped = true
                spinner___.center = CGPoint(x: loadingView.frame.width / 2 , y: loadingView.frame.height / 2)
                spinner___.backgroundColor=UIColor.clear
                spinner___.startAnimating()
            loadingView.addSubview(spinner___)

            let  _myLabel = _Label(frame: CGRect(x: loadingView.frame.origin.x, y: loadingView.frame.size.height+loadingView.frame.origin.y, width: 230, height: 50), txtString: "جاري تحميل البيانات \n برجاء الانتظار",font_Size : 16)
                _myLabel.center = CGPoint(x: _View__IndicatorW/2, y: _myLabel.frame.origin.y + 20)
                _myLabel.textColor = UIColor.white
            self.addSubview(_myLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}

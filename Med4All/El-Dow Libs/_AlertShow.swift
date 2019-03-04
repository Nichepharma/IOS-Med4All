//
//  _AlertShow.swift
//  PromotersApp
//
//  Created by Yahia on 4/25/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

import UIKit

class _AlertShow: NSObject {

    init( str_title : String ,  str_msg : String ,  str_btn : String) {
        super.init()
        let _Login_alert = UIAlertView(title:str_title , message: str_msg , delegate: nil, cancelButtonTitle: str_btn  )
        _Login_alert.show()

    }
    func show(representOnView : AnyObject ) {
        let alert = UIAlertController(title: ">>>>", message: "Test", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        alert.popoverPresentationController?.sourceView = representOnView.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: representOnView.view.bounds.size.width / 2.0 - 105 ,
                                                                 y: representOnView.view.bounds.size.height / 2.0 + 70 ,
                                                                 width: 1.0, height: 1.0)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

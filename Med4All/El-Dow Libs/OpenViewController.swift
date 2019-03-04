//
//  OpenOtherViewController.swift
//  AlfSalama
//
//  Created by Yahia El-Dow on 1/10/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class OpenViewController: NSObject {

    static func openWith(controller_name  : String){
        OperationQueue.main.addOperation {
        let storyboard_name  =  VarConfig.StoryboardIdentifier.storyboard_name
        let mainStoryboard = UIStoryboard(name:storyboard_name , bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier:controller_name) as UIViewController
        if let rootVC = topMostController() as? UIViewController {
           rootVC.present(vc, animated: true, completion: nil)
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        }


    }

   static func topMostController() -> AnyObject {
    if let vc = UIApplication.shared.keyWindow?.rootViewController {
        var topController =  vc
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
        }

   return NSNull()
    }

}


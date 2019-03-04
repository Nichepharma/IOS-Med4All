//
//  SplashScreen.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/30/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit


class SplashScreen: UIViewController {
    override func viewDidAppear(_ animated: Bool) {

//        NotificationMangement.sendNotificationToTopic(topic : "general" , isSend: {
//            t in
//            print(t)
//        })

//        RequestModel.getRequestByID(requestID: "40",
//                                    requestDic: {
//            res in
//            print (res)
//        })

        
        if let uid = UserInfo.getBy(key: Users.userProfileKey.key._u_id) as? String {

            if uid != ""  {
                StaticVar.requestDic.removeAll()
                self.performSegue(withIdentifier: "seg_request", sender: self )
            }
        }else{
             StaticVar.requestDic.removeAll()
            self.performSegue(withIdentifier: "seg_login", sender: self )
            
        }


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
     */


}

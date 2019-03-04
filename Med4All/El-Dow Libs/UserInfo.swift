//
//  SettingsModel.swift
//  El Tahrir News
//
//  Created by Yahia El-Dow on 6/10/16.
//  Copyright © 2016 Production Code. All rights reserved.
//


import UIKit

 class UserInfo : UserDefaults {
  
    override init?(suiteName suitename: String?) {
        super.init(suiteName: suitename)
    }
    
    
    func set ( myKey : String ,  myValue :  AnyObject)  {
        self.set(myValue, forKey: myKey)
        //  Save to disk
        let didSave = self.synchronize()
        if !didSave {
     //  Couldn't save (I've never seen this happen in real world testing)
            print("data Not Saved .. UserInfo")
        }
    }

    static func getBy(key : String = "") -> Any {

        if UserDefaults().object(forKey: key) == nil {
            //  Doesn't exist
            return NSNull() ;
        } else {
            let currentLevel = UserDefaults().object(forKey: key)
            return currentLevel! as Any
        }
        
    }
    
    func clear_data(myKey : String )  {
        self.removeObject(forKey: myKey)
    }

    static func clearAllInfo(){
        let appDomain = Bundle.main.bundleIdentifier!
        self.standard.removePersistentDomain(forName: appDomain)
    }
}

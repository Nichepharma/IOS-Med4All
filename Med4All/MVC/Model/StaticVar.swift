//
//  StaticVar.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/14/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import Alamofire

class StaticVar: NSObject {
    static var deviceToken = ""
    static var serverDate_and_Time =  ""
    static var user_id    =  UserInfo.getBy(key: Users.userProfileKey.key._u_id)
    static var userTypeID : Int = {
        if (UserInfo.getBy(key: Users.userProfileKey.key._type_id) as? String) == "2" {
            return 2
        }else {
            return 1
        }
    }()
    static var requestDic : [Request] = [Request]()
    static let favouritRequestArray : NSMutableArray =  DBManager.getSharedInstance().getFavouritIDs()

    static let SERVER_URL = "http://www.nichepharma.com/med4all/_tagFile.php";
    static let SERVER_NOTIFICATION_URL = "http://nichepharma.com/med4all/notification/index.php";

    static let server_url = URL(string:SERVER_URL )!
    static let httpMethod =  HTTPMethod.post
    static let urlEncoding = URLEncoding.default
    static let headers = ["Content-Type": "application/x-www-form-urlencoded"]


    static var locationDataSetter = [String : Any]()




}

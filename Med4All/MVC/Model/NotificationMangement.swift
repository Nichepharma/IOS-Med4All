//
//  NotificationMangement.swift
//  Med4All
//
//  Created by Yahia El-Dow on 4/2/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Alamofire
import SwiftyJSON

class NotificationMangement: NSObject {
    private static let server_url = URL(string:StaticVar.SERVER_NOTIFICATION_URL )!
    private static let httpMethod =  HTTPMethod.post
    private static let urlEncoding = URLEncoding.default
    private static let headers = ["Content-Type": "application/x-www-form-urlencoded"]

    

    //TODO: NOTIFICATION METHODS

    //MARK: SUBSCRIPE TOPIC
   static func subscripTopics (topic : String){
        Messaging.messaging().subscribe(toTopic: "/topics/\(topic)")
    }
    //MARK: UNSUBSCRIPE TOPIC
   static func unSubscripeTopic(topic : String ) {
        Messaging.messaging().unsubscribe(fromTopic: "/topics/\(topic)")
    }

    class func sendNotificationToTopic(topic : String , requestID : String ,   isSend : @escaping (_ request : Any)->()){
        let parameters : [String : Any] = ["notificationType" : "sendToTopic" ,
                                           "token_id" : "\(topic)" ,
                                           "title" :"الدواء للجميع" ,
                                           "body" : "طلب جديد في منطقتك" ,
                                           "request_id" :requestID ,
                                            ]
        Alamofire.request(server_url,
                          method: httpMethod ,
                          parameters: parameters ,
                          encoding: urlEncoding  ,
                          headers: headers )
            .validate(statusCode: 200..<300)
            .responseJSON {   response in
                switch response.result
                {
                case .failure(let error) :
                    print("> Error on Response JSON " , error)
                    _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention   ,
                                         str_msg:   VarConfig.Alert_msgIdentifier.DATA_NOT_SENT         ,
                                         str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    isSend(false)
                    return
                case .success(let value):
                    isSend(value)
                    return
                }
        }
    }

    class func sendNotificationToUser(token : String , body : String =  "تم قبول طلبك" ,  isSend : @escaping (_ request : Any)->()){
        let parameters : [String : Any] = ["notificationType" : "token" ,
                                           "token_id" : "\(token)" ,
                                            "title" :"الدواء للجميع" ,
                                            "body" : body
        ]
        Alamofire.request(server_url,
                          method: httpMethod ,
                          parameters: parameters ,
                          encoding: urlEncoding  ,
                          headers: headers )
            .validate(statusCode: 200..<300)
            .responseJSON {   response in
                switch response.result
                {
                case .failure(let error) :
                    print("> Error on Response JSON " , error)
                    _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention   ,
                                         str_msg:   VarConfig.Alert_msgIdentifier.DATA_NOT_SENT         ,
                                         str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    isSend(false)
                    return
                case .success(let value):
                    isSend(value)
                    return
                }
        }
    }




}

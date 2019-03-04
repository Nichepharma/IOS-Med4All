//
//  RequestModel.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/15/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestModel: NSObject {

    private static let server_url = URL(string:StaticVar.SERVER_URL )!
    private static let httpMethod =  HTTPMethod.post
    private static let urlEncoding = URLEncoding.default
    private static let headers = ["Content-Type": "application/x-www-form-urlencoded"]




    class func getNewRequestByUserID( requestStatus : Int ,  requestCreated : @escaping (_ requestDic : Any)->()){
          RequestModel.get_serverTime()
        let data : [String : Any] = [Request.RequestKey.key._donator_id : StaticVar.user_id  ,
                                     Request.RequestKey.key._req_status : requestStatus  ,
                                     ]


        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "GET_REQUEST_BY_USER".uppercased() ,
                                           "data" : data]
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
                    _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                         str_msg: VarConfig.Alert_msgIdentifier.DATA_NOT_SENT  ,
                                         str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    requestCreated(NSNull())

                    return
                case .success(let value):
                    requestCreated(value)
                    return

                }

        }

    }



    class func getRequestByID (requestID : String , requestDic :@escaping(_ requestDic : Any)->()  ){
      RequestModel.get_serverTime()
        let data : [String : Any] = [Request.RequestKey.key._req_id :  requestID]

        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "GET_REQUEST_BY_ID".uppercased() ,
                                           "data" : data]
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
                    requestDic(NSNull())

                    return
                case .success(let value):
                    requestDic(value)
                    return
                    
                }
        }
        
        
    }




    class func getVolunteerRequest( areaID : Any ,  requestArray : @escaping (_ requestDic : Any)->()){
      RequestModel.get_serverTime()
        let data : [String : Any] = [ Request.RequestKey.key._area_id : areaID ]

        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "GET_VOLUNTEER_REQUEST".uppercased() ,
                                           "data" : data]
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
                    requestArray(NSNull())
                    return
                case .success(let value):
                    requestArray(value)
                    return

                }


        }


    }

    class func getArchiveVolunteerRequest(requestStatus : Int , requestCreated : @escaping (_ requestDic : Any)->()){
      RequestModel.get_serverTime()
        let data : [String : Any] = [ Request.RequestKey.key._volanteer_id : StaticVar.user_id ,
                                      Request.RequestKey.key._req_status : requestStatus]

//        print(data)
        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "GET_ARCHIVE_VOLUNTEER_REQUEST".uppercased() ,
                                           "data" : data]
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
                    _ = _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention   ,
                                        str_msg:   VarConfig.Alert_msgIdentifier.DATA_NOT_SENT         ,
                                        str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    requestCreated(NSNull())
                    return
                case .success(let value):
                    // print(value)
                    requestCreated(value)
                    return

                }
        }


    }

    class func changeRequestStatus(request_id : Any , request_status : Any , didChangedRequestValue : @escaping(_ didChanged : Any)->()){
      RequestModel.get_serverTime()
        var userID  = StaticVar.user_id
        if request_status as! Int == 1 {
            userID = "NULL"
        }
        let data : [String : Any] = [ Request.RequestKey.key._req_id : request_id  ,
                                      Request.RequestKey.key._volanteer_id : userID ,
                                      "newStatus" : request_status
        ]

        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "CHANGE_REQUEST_STATUS".uppercased() ,
                                           "data" : data]
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
                    didChangedRequestValue(false)
                    return
                case .success(let value):

                    guard let result = value as? Bool , result == true else {
                         _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention   ,
                                              str_msg:  "لا تستطيع تغير حاله الطلب الان "        ,
                                              str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                         didChangedRequestValue(false)
                         return
                    }
                    didChangedRequestValue(result)

                    return

                }


        }
    }



    class func deleteRequest(request_id : Any  , didChangedRequestValue : @escaping(_ didChanged : Any)->()){
      RequestModel.get_serverTime()
        let data : [String : Any] = [ Request.RequestKey.key._req_id : request_id ]

        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "DELETE_REQUEST".uppercased() ,
                                           "data" : data]
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
                    didChangedRequestValue(false)
                    return
                case .success(let value):
                    didChangedRequestValue(value)
                    return

                }


        }
    }

private static func get_serverTime(){
          if    StaticVar.serverDate_and_Time != ""{
               return
          }
          Date_and_Time.getServerDate(date_and_time:{ res in
               StaticVar.serverDate_and_Time = res
          })
          let sleep  = NSDate(timeIntervalSinceNow: 3) as Date
               RunLoop.current.run(until: sleep)
          
     }


}

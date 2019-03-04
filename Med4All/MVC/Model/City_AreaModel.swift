//
//  City_AreaModel.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/19/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class City_AreaModel: NSObject {

    private static let server_url = URL(string:StaticVar.SERVER_URL )!
    private static let httpMethod =  HTTPMethod.post
    private static let urlEncoding = URLEncoding.default
    private static let headers = ["Content-Type": "application/x-www-form-urlencoded"]


    class func getCities( request : @escaping (_ cityDic : Any)->()){
        let data : [String : Any] = ["country_id":1]

        let parameters : [String : Any] = ["include" : "areaModel" ,
                                           "ask" : "GETCITY".uppercased() ,
                                           "data" :data
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
                    request(NSNull())
                    return
                case .success(let value):
                    request(value)
                    return
                }

        }
        
    }
    
    
    
    class func getAreas(city_id : Int , request : @escaping (_ cityDic : Any)->()){
        let data : [String : Any] = ["city_id":city_id]

        let parameters : [String : Any] = ["include" : "areaModel" ,
                                           "ask" : "GETAREA".uppercased() ,
                                           "data" :data
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
                    request(NSNull())
                    return
                case .success(let value):
                    request(value)
                    return
                }


        }

    }

}

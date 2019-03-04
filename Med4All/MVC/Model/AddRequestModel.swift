                                                                                                       //
//  AddRequestModel.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/14/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddRequestModel: NSObject {

    private static let server_url = URL(string:StaticVar.SERVER_URL )!
    private static let httpMethod =  HTTPMethod.post
    private static let urlEncoding = URLEncoding.default
    private static let headers = ["Content-Type": "application/x-www-form-urlencoded"]


    class func createNewRequest( requestInfo : Request ,
                                 requestCreated : @escaping (_ succsess : Bool)->()){

        var med_name = requestInfo.getRequestMedicineName() as! String
        var address = requestInfo.getRequestAddressDetail() as! String
        var note = requestInfo.getRequestNote() as! String

            med_name.replaceSpecialCharacter()
            address.replaceSpecialCharacter()
            note.replaceSpecialCharacter()


        let data : [String : Any] = [ Request.RequestKey.key._donator_id :  StaticVar.user_id ,
                                     // Request.RequestKey.key._req_date : Date_and_Time.getDeviceDateNow() ,
                                      Request.RequestKey.key._city_id : requestInfo.getRequestCityID() ,
                                      Request.RequestKey.key._country_id : requestInfo.getRequestCountryID() ,
                                      Request.RequestKey.key._area_id : requestInfo.getRequestAreaID() ,
                                      Request.RequestKey.key._address_detail : address ,
                                      Request.RequestKey.key._donator_timeAvailable : requestInfo.getRequestDonatorTimeAvailable() ,
                                      Request.RequestKey.key._req_med_name : med_name ,
                                      Request.RequestKey.key._item_count : requestInfo.getRequestItemCount() ,
                                      Request.RequestKey.key._req_note : note
                                    ]

//        print(data)

        let parameters : [String : Any] = ["include" : "requestModel" ,
                                           "ask" : "CREATE".uppercased() ,
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
                    requestCreated(false)
                    return
                case .success(let value):
                    if value is Int && value as! Int == 0 {
                        requestCreated(true)
                        return
                    }
                    if let requestID = Int(value as! String){
                        if requestID > 0
                        {

                            NotificationMangement.sendNotificationToTopic(topic: requestInfo.getRequestAreaID() as! String ,
                                                                          requestID: "\(requestID)", isSend: {
                                                                            resultNotification in
                            })
                            requestCreated(true)
                            return
                        }
                    }

                        requestCreated(false)
                        return



                }
        }

    }







    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }


    
}

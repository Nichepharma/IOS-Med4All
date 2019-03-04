//
//  UserModel.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/12/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import  Firebase


class UserModel: NSObject    {
    let viewController : UIViewController = {
        let windows = UIWindow(frame: (UIScreen.screens.first?.bounds)!).rootViewController
            return windows!
        }()
    private static let server_url = URL(string:StaticVar.SERVER_URL )!
    private static let httpMethod =  HTTPMethod.post
    private static let urlEncoding = URLEncoding.default
    private static let headers = ["Content-Type": "application/x-www-form-urlencoded"]

    
    class func userAuthentication ( u_email : String , u_password : String ,
                                    Result:@escaping(_ result : Any)->() ) {

        if StaticVar.deviceToken == "" {
            if let refreshedToken = InstanceID.instanceID().token()
            {
                StaticVar.deviceToken =  refreshedToken
            }
        }
//        print(FIRInstanceID.instanceID().token())

        // prepare json data
        let parameters : [String : Any] = ["include" : "userModel" ,
                          "ask" : "AUTH".uppercased() ,
                          "data": [
                                   Users.userProfileKey.key._email : u_email ,
                                   Users.userProfileKey.key._password : u_password ,
                                   Users.userProfileKey.key._device_token : StaticVar.deviceToken
                                    ] ,
                                     ]
        print(parameters)
        
        Alamofire.request(server_url,
                          method: httpMethod ,
                          parameters: parameters ,
                          encoding: urlEncoding  ,
                          headers: headers )
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in

                switch response.result
                {
                case .failure(let error) :
                    print("> Error on Response JSON " , error)
                    Result(false)
                    break
                case .success(let value):
                    if let userProfile : [String : Any] = value as? [String : Any]{
                        Result(userProfile)
                        return
                    }
                    Result(false)
                    break
                }
            })
    }

    class func canCompliteSignUp( userInfo : [String : Any] ,
                                  ErrorCode : @escaping (_ errorCode : Int)->()){

        var data : [String : Any] = [String : Any]()

        for element in userInfo.keys {
            data [element] = userInfo[element]
        }



        let parameters : [String : Any] = ["include" : "userModel" ,
                                           "ask" : "EMAIL_PHONE_CHECKED".uppercased() ,
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
                                         str_msg: VarConfig.Alert_msgIdentifier.authNotCreated ,
                                         str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    break
                case .success(let value):
                    print(value)
                    if let code = value as? Int {
                        ErrorCode(code)
                        return
                    }

                }
                
                ErrorCode(4)

        }
        
        
        
        
    }





 class func createUserProfile( userInfo : [String : Any] ,
                               userProfileCreated : @escaping (_ succsess : Bool , _ userID : Any )->()){

        var data : [String : Any] = [String : Any]()

        for element in userInfo.keys {
            data [element] = userInfo[element]
        }



        let parameters : [String : Any] = ["include" : "userModel" ,
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
                   _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                        str_msg: VarConfig.Alert_msgIdentifier.authNotCreated ,
                                        str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    break
                case .success(let value):
                    print(value)
                    if let succ = value as? String {
                        if succ != "0"{
                            userProfileCreated(true ,  succ)
                            return
                            }
                        }
                    userProfileCreated(false , 0)
                    return
                }

                userProfileCreated(false , 0)

            }




    }
    class func getUserProfileByID (userID : String ,
                                   Result:@escaping(_ result : Any)->() ) {

        let data : [String : Any] = [Users.userProfileKey.key._u_id : userID]
        let parameters : [String : Any] = ["include" : "userModel" ,
                                           "ask" : "GET_USER_BY_ID".uppercased() ,
                                           "data" : data]
        print(parameters)
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
                                         str_msg: VarConfig.Alert_msgIdentifier.authNotCreated ,
                                         str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    break
                case .success(let value):
                    Result(value)
                    return
                }
                Result(NSNull())

        }


    }

    class func forgetPassword (email : String ,
                                   Result:@escaping(_ result : Any)->() ) {

        let data : [String : Any] = [Users.userProfileKey.key._email : email]
        let parameters : [String : Any] = ["include" : "userModel" ,
                                           "ask" : "FORGET_PASSWORD".uppercased() ,
                                           "data" : data]
        print(parameters)
        Alamofire.request(server_url,
                          method: httpMethod ,
                          parameters: parameters ,
                          encoding: urlEncoding  ,
                          headers: headers )
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result
                {
                case .failure(let error) :
                    print("> Error on Response JSON " , error)
                    break
                case .success(let value):
                     if let res = value as? NSDictionary , let emailIsValid = res.object(forKey: "succ") as? String  {
                        if emailIsValid != "0"{
                            Result(true)
                        }else{
                        Result(false)
                        }
                     }
                    return
                }
            })
        
    }
    
    
    class func resetNotificationBadged_number(resetSuccsess : @escaping (_ succsess : Bool)->() ){
        
        var data : [String : Any] = [String : Any]()
        data[Users.userProfileKey.key._device_token] = StaticVar.deviceToken
        data[Users.userProfileKey.key._u_id]         = StaticVar.user_id
        
        let parameters : [String : Any] = ["include" : "userModel" ,
                                           "ask" : "RESET_BADGED_NUMBER".uppercased() ,
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
                    break
                case .success(_):
                    resetSuccsess(true)
                    return
                }
                resetSuccsess(false)
                
        }
    }
    

    
    class func updateUserProfile( userInfo : [String : Any] ,
                                  userProfileUpdated : @escaping (_ succsess : Bool)->()){

        var data : [String : Any] = [String : Any]()

        for element in userInfo.keys {
            data [element] = userInfo[element]
        }

        let parameters : [String : Any] = ["include" : "userModel" ,
                                           "ask"     : "UPDATE_USER_PROFILE".uppercased() ,
                                           "data"    : data]
        Alamofire.request(server_url,
                          method: httpMethod ,
                          parameters: parameters ,
                          encoding: urlEncoding  ,
                          headers: headers )
            .validate(statusCode: 200..<300)
            .response(completionHandler: {
                response in
                print(response)
            })
            .responseJSON {   response in
                switch response.result
                {
                case .failure(let error) :
                    print("> Error on Response JSON " , error)

                    _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                         str_msg: VarConfig.Alert_msgIdentifier.authNotCreated ,
                                         str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                    userProfileUpdated(false)

                    break
                case .success(let value):
                    print(value)
                    if let succ = value as? Bool {
                        userProfileUpdated(succ)
                        return
                    }

                    userProfileUpdated(false)
                    return
                }
                
                userProfileUpdated(false)
                
        }
        
    }
    

    //MARK: SAVE USER INFOROMATION ON UserDefaults (SHARED INSTANCE)
    static func saveUserInfo(user : Users ){
        if user.getUID() != "" {
            UserInfo().set(user.getUID(), forKey: Users.userProfileKey.key._u_id)
            StaticVar.user_id = user.getUID()
        }
        if user.get_user_f_name() != "" {
            UserInfo().set(user.get_user_f_name(), forKey: Users.userProfileKey.key._f_name)
        }
        if user.get_user_l_name() != "" {
            UserInfo().set(user.get_user_l_name(), forKey: Users.userProfileKey.key._l_name)
        }
        if user.get_user_phone() != "" {
            UserInfo().set(user.get_user_phone(), forKey: Users.userProfileKey.key._phone)
        }
        if user.get_user_email() != "" {
            UserInfo().set(user.get_user_email(), forKey: Users.userProfileKey.key._email)
        }
        if user.get_user_country_id() != "" {
            UserInfo().set(user.get_user_country_id(), forKey: Users.userProfileKey.key._country_id)
        }
        if user.get_user_country_name() != ""{
            UserInfo().set(user.get_user_country_name(), forKey: Users.userProfileKey.key._country_name)
        }
        if user.get_user_city_id() != "" {
            UserInfo().set(user.get_user_city_id(), forKey: Users.userProfileKey.key._city_id)
        }
        if user.get_user_city_name() != "" {
            UserInfo().set(user.get_user_city_name(), forKey: Users.userProfileKey.key._city_name)
        }
        if user.get_user_area_id() != "" {
            UserInfo().set(user.get_user_area_id() , forKey:  Users.userProfileKey.key._area_id)
        }
        if user.get_user_area_name() != "" {
            UserInfo().set(user.get_user_area_name() , forKey:  Users.userProfileKey.key._area_name)
        }
        if user.get_user_address() != "" {
            UserInfo().set(user.get_user_address() , forKey:  Users.userProfileKey.key._address)
        }
        if user.get_user_type_id() != "" {
            UserInfo().set(user.get_user_type_id(), forKey:  Users.userProfileKey.key._type_id)
              StaticVar.userTypeID = Int(user.get_user_type_id())!
            if Int(user.get_user_type_id())! == 2 {
                NotificationMangement.subscripTopics(topic: user.get_user_area_id())
            }
        }
        if user.get_user_type_value() != "" {
            UserInfo().set(user.get_user_type_value(), forKey:  Users.userProfileKey.key._type_value)
        }
    }
    
}

//
//  Users.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class Users: NSObject {

    struct userProfileKey {
        static let key = (
            _u_id   : "id",
            _f_name : "u_f_name" ,
            _l_name : "u_l_name" ,
            _phone  : "u_phone" ,
            _email  : "u_email",
            _password :  "u_password" ,
            _country_id : "u_country_id" ,
            _country_name : "country_name" ,
            _city_id    : "u_city_id" ,
            _city_name  : "city_name" ,
            _area_id    : "u_area_id" ,
            _area_name  : "area_name" ,
            _address    :"u_address",
            _type_id    : "u_type" ,
            _type_value : "type_value" ,
            _device_token : "u_token"
        )}


    private var user_id         = ""
    private var user_f_name     = ""
    private var user_l_name     = ""
    private var user_phone      = ""
    private var user_email      = ""
    private var country_id      = ""
    private var country_name    = ""
    private var city_id         = ""
    private var city_name       = ""
    private var area_id         = ""
    private var area_name       = ""
    private var address_detail  = ""
    private var type_value      = ""
    private var type_id         = ""
    private var device_token    = ""


    func getUID() -> String {
        return user_id
    }
    func get_user_f_name() -> String {
        return user_f_name
    }
    func get_user_l_name() -> String {
        return user_l_name
    }
    func get_user_fullName() -> String {
        return user_f_name + "" + user_f_name
    }
    func get_user_phone() -> String {
        return user_phone
    }
    func get_user_email() -> String {
        return user_email
    }
    func get_user_country_id() -> String {
        return country_id
    }
    func get_user_country_name() -> String {
        return country_name
    }
    func get_user_city_id() -> String {
        return city_id
    }
    func get_user_city_name() -> String {
        return city_name
    }
    func get_user_area_id() -> String {
        return area_id
    }
    func get_user_area_name() -> String {
        return area_name
    }
    func get_user_address () -> String {
        return address_detail
    }
    func get_user_type_id() -> String {
        return type_id
    }
    func get_user_type_value() -> String {
        return type_value
    }
    func get_user_device_token() -> String {
        return device_token
    }




    func setUID(val : String) {
        if val.isEmpty {
            return
        }
        user_id = val
    }
    func set_user_f_name(val : String) {
        if val.isEmpty {
            return
        }
        user_f_name = val
    }
    func set_user_l_name(val : String)  {
        if val.isEmpty {
            return
        }
        user_l_name = val
    }
    func set_user_phone(val : String)  {
        if val.isEmpty {
            return
        }
        user_phone = val
    }
    func set_user_email(val : String)  {
        if val.isEmpty {
            return
        }
        user_email = val
    }
    func set_user_country_id(val : String)  {
        if val.isEmpty {
            return
        }
        country_id = val
    }
    func set_user_country_name(val : String)  {
        if val.isEmpty {
            return
        }
        country_name = val
    }
    func set_user_city_id(val : String)  {
        if val.isEmpty {
            return
        }
        city_id = val
    }
    func set_user_city_name(val : String)  {
        if val.isEmpty {
            return
        }
        city_name = val
    }
    func set_user_area_id(val : String)  {
        if val.isEmpty {
            return
        }
        area_id = val
    }
    func set_user_area_name(val : String)  {
        if val.isEmpty {
            return
        }
        area_name = val
    }
    func set_user_address (val : String)  {
        if val.isEmpty {
            return
        }
        address_detail = val
    }
    func set_user_type_id(val : String)  {
        if val.isEmpty {
            return
        }
        type_id = val
    }
    func set_user_type_value(val : String)  {
        if val.isEmpty {
            return
        }
        type_value = val
    }
    func set_user_device_token(val : String)  {
        if val.isEmpty {
            return
        }
        device_token = val
    }
}

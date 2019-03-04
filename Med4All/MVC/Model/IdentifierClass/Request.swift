//
//  Request.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/14/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class Request: NSObject {

    struct RequestKey {
        static let key = (_req_id : "id" ,
                          _req_med_name : "med_name" ,
                          _req_date : "request_date" ,
                          _donator_id : "donator_id" ,
                          _donator_f_name :"donator_f_name" ,
                          _donator_l_name : "donator_l_name" ,
                          _donator_phone  :"donator_phone" ,
                          _donator_token  :"donator_token" ,
                          _country_id  : "country_id" ,
                          _country_name : "country_name" ,
                          _city_id  : "city_id",
                          _city_name  : "city_name",
                          _area_id :  "area_id" ,
                          _area_name : "area_name" ,
                          _address_detail : "address_detail" ,
                          _donator_timeAvailable : "donator_availableTime" ,
                          _item_count : "item_count" ,
                          _volanteer_id :"volunteer_id" ,
                          _volanteer_phone :"volunteer_phone" ,
                          _volanteer_f_name :"volunteer_f_name" ,
                          _volanteer_l_name :"volunteer_l_name" ,
                          _volanteer_token :"volunteer_token" ,
                          _req_note : "request_note" ,
                          _req_status : "request_status"
        )}



    private var request_id               = ""
    private var request_donator_f_name   = ""
    private var request_donator_l_name   = ""
    private var request_donator_phone    = ""
    private var request_donator_token    = ""
    private var request_date             = ""
    private var donator_id               = ""
    private var request_country_id       = ""
    private var request_country_name     = ""
    private var request_city_id          = ""
    private var request_city_name        = ""
    private var request_area_id          = ""
    private var request_area_name        = ""
    private var request_address_details  = ""
    private var donatorAvilableTime      = ""
    private var medicine_name            = ""
    private var request_item_count       = 0
    private var request_volunteer_id     = ""
    private var request_volunteer_f_name = ""
    private var request_volunteer_l_name = ""
    private var request_volunteer_phone  = ""
    private var request_volunteer_token  = ""
    private var request_note            = ""
    private var request_status          = 1


    func getRequestID() -> Any                   { return request_id }
    func getRequestDonator_fName() -> Any        { return request_donator_f_name }
    func getRequestDonator_lName() -> Any        { return request_donator_l_name }
    func getRequestDonator_phone() -> Any        { return request_donator_phone }
    func getRequestDonator_token() -> Any        { return request_donator_token }

    func getRequestDate() -> Any                 { return request_date }
    func getRequestDonatorID() -> Any            { return donator_id }
    func getRequestCountryID() -> Any            { return request_country_id }
    func getRequestCityID() -> Any               { return request_city_id }
    func getRequestAreaID() -> Any               { return request_area_id }
    func getRequestCountryName() -> Any          { return request_country_name }
    func getRequestCityName() -> Any             { return request_city_name }
    func getRequestAreaName() -> Any             { return request_area_name }
    func getRequestAddressDetail() -> Any        { return request_address_details }
    func getRequestDonatorTimeAvailable() -> Any { return donatorAvilableTime }
    func getRequestMedicineName()-> Any          { return medicine_name }
    func getRequestItemCount() -> Any            { return request_item_count }
    func getRequestVolunteerID() -> Any          { return request_volunteer_id }
    func getRequestVolunteer_f_name() -> Any     { return request_volunteer_f_name }
    func getRequestVolunteer_l_name() -> Any     { return request_volunteer_l_name }
    func getRequestVolunteer_phone() -> Any      { return request_volunteer_phone    }
    func getRequestVolunteer_token() -> Any      { return request_volunteer_token    }

    func getRequestNote() -> Any                 { return request_note }
    func getRequestStatus() -> Any               { return request_status }

    
    func setRequestID(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_id = val
        return true
    }
    func setRequestDate(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_date = val
        return true
    }
    func setRequestDonatorID(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        donator_id = val
        return true
    }
    func setRequestDonator_fName (val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_donator_f_name = val
        return true
    }

    func setRequestDonator_lName (val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_donator_l_name = val
        return true
    }
    func setRequestDonator_phone (val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_donator_phone = val
        return true
    }
    func setRequestDonator_token (val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_donator_token = val
        return true
    }
    func setRequestCountryID(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_country_id = val
        return true
    }
    func setRequestCountryName(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_country_name = val
        return true
    }
    func setRequestCityID(val : String) -> Bool {
        if val.isEmpty || val == ""  {
            return false
        }
        request_city_id = val
        return true
    }
    func setRequestCityName(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_city_name = val
        return true
    }
    func setRequestAreaID(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_area_id = val
        return true
    }
    func setRequestAreaName(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_area_name = val
        return true
    }

    func setRequestAddressDetail(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_address_details = val
        return true
    }
    func setRequestDonatorTimeAvailable(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        donatorAvilableTime = val
        return true
    }
    func setRequestMedicineName(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        medicine_name = val
        return true
    }

    func setRequestItemCount(val : Int) -> Bool {
        if val == 0 {
            return false
        }
        request_item_count = val
        return true
    }
    func setRequestVolunteerID(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_volunteer_id = val
        return true
    }
    func setRequestVolunteer_phone(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_volunteer_phone = val
        return true
    }
    func setRequestVolunteer_token(val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_volunteer_token = val
        return true
    }
    func setRequestVolunteer_fName (val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_volunteer_f_name = val
        return true
    }

    func setRequestVolunteer_lName (val : String) -> Bool {
        if val.isEmpty || val == "" {
            return false
        }
        request_volunteer_l_name = val
        return true
    }

    func setRequestNote(val : String) -> Bool {
        if val.isEmpty {
            return false
        }
        request_note = val
        return true
    }

    func setRequestStatus(val : Int) -> Bool {
        if val == 0 {
            return false
        }
        request_status = val
        return true
    }
}

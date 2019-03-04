//
//  TimeAgoCalaculate.swift
//  Med4All
//
//  Created by Yahia El-Dow on 9/20/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Date_and_Time: NSObject {
    static let deviceDateFormat  = "YYYY-MM-dd HH:mm:ss"

    static func calculate (requestTime : String) -> String{
    let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = deviceDateFormat
        guard let startDate = dateFormatter.date(from: requestTime) else{ return "" }
        guard  var endDate   = dateFormatter.date(from: StaticVar.serverDate_and_Time) else{ return "" }
         endDate = endDate.addingTimeInterval(getDeffrenceBettwenDate())
     
        let cal = NSCalendar.current
        let components = cal.dateComponents([.day , .month , .year , .hour , .minute],
                                            from:startDate ,
                                            to: endDate)

        var str_Return  = " منذ "

        guard let year   = components.year   else { return "" }
        guard let month  = components.month  else { return "" }
        guard let day    = components.day    else { return "" }
        guard let hour   = components.hour   else { return "" }
        guard let minute = components.minute else { return "" }
          // check if any value less than 0
     if year < 0 || month < 0 || day < 0 || hour < 0 || minute < 0 {
          Date_and_Time.getServerDate(date_and_time:{ res in StaticVar.serverDate_and_Time = res })
          let sleep  = NSDate(timeIntervalSinceNow: 3) as Date
          RunLoop.current.run(until: sleep)
          return "" ;
          }
        if year != 0  {
            str_Return = str_Return + "\(year)" + " سنه"
            return str_Return
        }
        if month != 0  {
            if month ==  1 {
                str_Return = str_Return + "شهر"
            } else if  month ==  2 {
                str_Return = str_Return + "شهرين"

            }else if month < 11 && month > 2 {
                str_Return = str_Return + "\(month)" + " شهور "

            }else  {
                str_Return = str_Return + "\(month)" + " شهر "

            }
            return str_Return
        }
        if day != 0  {
            if day == 1 {
                str_Return = str_Return + "يوم"
            }else if day ==  2 {
                str_Return = str_Return + "يومين"
            }else if day < 11 && day > 2 {
                str_Return = str_Return + "\(day )" + "  ايام "
            } else{
                str_Return = str_Return + "\(day )" + "  يوم "
            }
            return str_Return
        }

        if hour != 0  {

            if hour == 1 {
                str_Return = str_Return +  " ساعة "
            }else if hour == 2 {
                str_Return = str_Return +  " ساعتين "
            }else if hour < 11 {
                str_Return = str_Return + "\(hour)" + " ساعات "
            }else{
                str_Return = str_Return + "\(hour)" + " ساعة "
            }
            return str_Return
        }


        if minute != 0  {
            if minute > 59  {
                return " ساعة "
            }
            if minute == 1 {
                str_Return = str_Return +  " دقيقة "
            }else if minute == 2 {
                str_Return = str_Return +  " دقيقتين "
            }else if minute  < 11 {
                str_Return = str_Return + "\(minute)" + " دقائق "
            }else{
                str_Return = str_Return + "\(minute)" + " دقيقة "
            }
            return str_Return
        }
        else {
            str_Return = "ألان"
            return str_Return
        }



    }



     static func getDeviceDateNow() -> String{
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = deviceDateFormat
        let date = dateFormatter.string(from: NSDate() as Date)
        return date
    }




     static var date_and_time_statrOpendevice = Date_and_Time.getDeviceDateNow()
     static func getDeffrenceBettwenDate()-> TimeInterval{
          let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = deviceDateFormat
          let deviceDateOpen =  dateFormatter.date(from: date_and_time_statrOpendevice)!
          let deviceDateNow  =   dateFormatter.date(from: getDeviceDateNow())!
          let timeInterval = deviceDateNow.timeIntervalSince(deviceDateOpen)
          return timeInterval
     }

     static func getServerDate(date_and_time :@escaping(_ result : String)->()) {
          if StaticVar.serverDate_and_Time != "" { date_and_time(StaticVar.serverDate_and_Time) }
     let server_url = URL(string:StaticVar.SERVER_URL )!
     let parameters : [String : Any] = ["include" : "getServerTime"]
     let httpMethod =  HTTPMethod.post
     let urlEncoding = URLEncoding.default
     let headers = ["Content-Type": "application/x-www-form-urlencoded"]
     Alamofire.request(server_url,method: httpMethod ,
                       parameters: parameters ,
                       encoding: urlEncoding  ,
                       headers: headers )
               .validate(statusCode: 200..<300)
          .responseString(completionHandler: { val in
               if val.value != nil {
                    date_and_time_statrOpendevice = Date_and_Time.getDeviceDateNow()
                    date_and_time(val.value!)
               }
               return
          })

     }

}

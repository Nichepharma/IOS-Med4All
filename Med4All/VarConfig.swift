//
//  VarConfig.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/12/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class VarConfig: NSObject {

    static let screenSize: CGRect = UIScreen.main.bounds

    struct StoryboardIdentifier {
        static let storyboard_name  = "Main"
        static let loginViewController_identifier = "LoginVC"
        static let user_homeViewController_identifier = "UserHomeVC"
        static let patientHomeIdentifier = "patientHomeVC"
        static let patientProfileEditIdentifier = "patientProfileVC"
        static let patientGuideIdentifier = "guideVC"
        static let youtubeIdentifier = "youtubeVC"

    }

    struct Alert_msgIdentifier {

        static let alertTitleDone = "تم"
        static let alertTitleWorng  = ""
        static let alertTitleAttention = ""
        static let alertButtonTitleDismiss  = "إخفاء"
        // required Message
        static let REQUIRED_EMAIL =  "أدخل البريد الإليكتروني"
        static let EMAIL_FORMAT   = "ادخل البريد الإليكتروني بشكل صحيح"
        static let REQUIRED_PASSWORD =  "أدخل الرقم السري"
        static let PASSWORD_FORMAT = "كلمه السر لا بد و ان تتكون من ٦ احرف"
        static let REQUIRED_CITY = "أختار المحافظة"
        static let REQUIRED_AREA = "اختار المنطقة السكنية"
        static let REQUIRED_ADDRESS = "برجاء كتابة العنوان التفصيلي للسكن"
        //
        static let loginError = "هناك خطاء في البريد الإليكتروني او كلمه المرور"
        // Registration
        static let REQUIRED_F_NAME =  "أدخل الاسم الاول"
        static let REQUIRED_L_NAME =  "أدخل الاسم الثاني"
        static let REQUIRED_PHONE_NUMBER = "ادخل رقم الهاتف"
        static let PHONE_NUMBER_FORMAT = "إدخل رقم الهاتف بشكل صحيح"

        static let emailIsused = "هذا البريد الإليكتروني مسجل من قبل"
        static let phoneIsUsed  = "هذا الهاتف مسجل من قبل"
        static let email_phoneIsUsed  = "البريد الاليكتروني و رقم التليفون مسجل من قبل"
        static let authNotCreated = "لم تتم عمليه التسجيل بنجاح"

        static let DATA_NOT_SENT = "تم قطع الاتصال ، حاول مره اخري"
        static let DATA_SENT  = "تم إرسال طلبك بنجاح"
        static let ACCEPTT  = "نعم"
        static let CANCEL  = "لا"

        static let USER_UPDATED_PROFIEL_DONE  = "تم تحديث ملفك الشخصي بنجاح"
        static let USER_UPDATED_PROFIEL_FAILD = "لم تتم عمليه تعديل ملفك الشخصي بنجاح"
        static let SELECT_CITY_FIRIST = "برجاء اختيار المحافظة اولا"
    }

}

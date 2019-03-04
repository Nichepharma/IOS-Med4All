//
//  PhoneNumberVerificationViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 9/10/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class PhoneNumberVerificationViewController: UIViewController {
    
    @IBOutlet weak var txt_phoneNumber: UITextField!
    @IBOutlet weak var lbl_verifiedTitle: UILabel!
    @IBOutlet weak var txt_verified: UITextField!{
        didSet{ self.txt_verified.delegate = self }
    }
    @IBOutlet weak var lbl_currentPhoneNumber: UILabel!
    
    
    var userInfo = [String : Any ] ()
    private let phoneNumberVC_loader = _Indicator()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_verified.addTarget(self, action: #selector(textFieldTyping), for: .editingChanged)

        self.handelRecentCodeAgain()
        //  self.userInfo[Users.userProfileKey.key._phone] = "01001541296"
        
        
        guard let phoneNumber  = self.userInfo[Users.userProfileKey.key._phone] as? String else {
            self.dismiss(animated: true , completion: nil)
            return
        }
        self.lbl_currentPhoneNumber.text = "سيتم ارسال رمز التفعيل الي رقم \n" + phoneNumber
        sendVerificationCode(userPhoneNumber: phoneNumber)
        
    }
    //DOTO: CHECKED NUMBER OF TEXT TO SET VERIVICATION
    func textFieldTyping(textField:UITextField)
    {
        
        guard let codeCount = textField.text?.count else{ return }
        if codeCount > 5 {
            // DISMISS KEYBOARD
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.phoneNumberVerivicationCodeSubmit(UIButton())
        }
        
    }
    @IBAction func resendVerificationCode(_ sender: Any) {
        
        guard let phoneNumber  = self.userInfo[Users.userProfileKey.key._phone] as? String else {
            self.dismiss(animated: true , completion: nil)
            return
        }
        sendVerificationCode(userPhoneNumber: phoneNumber)
        handelRecentCodeAgain()
    }
    
    
    func sendVerificationCode(userPhoneNumber  : String)  {
        
        Auth.auth().languageCode = "AR";
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+2\(userPhoneNumber)",
        uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Auth Error is : " , error)
                return
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            
            UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
            UserDefaults.standard.synchronize()
        }
        
        
        /*
         Auth.auth().languageCode = "AR";
         PhoneAuthProvider.provider().verifyPhoneNumber("+2\(userPhoneNumber)") { (verificationID, error) in
         if let error = error {
         print(error)
         return
         }
         UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
         UserDefaults.standard.synchronize()
         }
         */
        
    }
    
    @IBAction func phoneNumberVerivicationCodeSubmit(_ sender: Any) {
        
        guard let authNumber =  self.txt_verified.text else { return }
        
        if authNumber.count < 4 {
            _ = _AlertShow(str_title: "", str_msg: "أدخل رمز التاكيد الصحيح", str_btn: "إخفاء")
            return
        }
        guard let verificationID = UserDefaults.standard.value(forKey: "firebase_verification") else {
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: authNumber)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                self.txt_verified.text  = ""
                _ = _AlertShow(str_title: "تنبيه", str_msg: "حدث خطاء برجاء المحاوله مره اخري", str_btn: "اخفاء")

                print(error)
                return
            }
            
            // ADD INDICATOR
            self.view.addSubview(self.phoneNumberVC_loader)
            // DISMISS KEYBOARD
            self.view.endEditing(true)
            // CALLING SERVER
            UserModel.createUserProfile(userInfo: self.userInfo, userProfileCreated: {
                (_success , userID) in
                if _success {
                    
                    self.phoneNumberVC_loader.removeFromSuperview()
                    SignUpViewController.cleareData()
                    self.phoneNumberVC_loader.removeFromSuperview()
                    self.userInfo[Users.userProfileKey.key._u_id] =  userID
                    self.handelUserInfoSaved()
                    
                    // OpenViewController.openWith(controller_name: "LoginVC")
                    return
                }
                _ = _AlertShow(str_title: "تنبيه", str_msg: "حدث خطاء برجاء المحاوله مره اخري", str_btn: "اخفاء")
                // REMOVE INDICATOR
                self.phoneNumberVC_loader.removeFromSuperview()
            })
        }
    }
    func handelUserInfoSaved(){
        let user = Users()
        guard let uID = self.userInfo[Users.userProfileKey.key._u_id] as? String else { return }
        user.setUID(val:uID)
        
        if let f_name = self.userInfo[Users.userProfileKey.key._f_name] as? String{
            user.set_user_f_name(val: f_name )
        }
        if let l_name = self.userInfo[Users.userProfileKey.key._l_name] as? String{
            user.set_user_l_name(val: l_name )
        }
        if let phone = self.userInfo[Users.userProfileKey.key._phone] as? String {
            user.set_user_phone(val:phone)
        }
        if let email = self.userInfo[Users.userProfileKey.key._email] as? String {
            user.set_user_email(val:email )
        }
        if let country_id = self.userInfo[Users.userProfileKey.key._country_id] as? Int  {
            user.set_user_country_id(val:"\(country_id)")
        }
        if let country_name = self.userInfo[Users.userProfileKey.key._country_name] as? String {
            user.set_user_country_name(val:country_name)
        }
        if let city_id = self.userInfo[Users.userProfileKey.key._city_id] as? Int {
            user.set_user_city_id(val:"\(city_id)" )
        }
        if let city_name = self.userInfo[Users.userProfileKey.key._city_name] as? String {
            user.set_user_city_name(val:city_name )
        }
        if let area_id = self.userInfo[Users.userProfileKey.key._area_id] as? Int {
            user.set_user_area_id(val:"\(area_id)" )
        }
        if let area_name = self.userInfo[Users.userProfileKey.key._area_name] as? String {
            user.set_user_area_name(val:area_name )
        }
        if let address =  self.userInfo[Users.userProfileKey.key._address] as? String {
            user.set_user_address(val:address )
        }
        if let type_id =  self.userInfo[Users.userProfileKey.key._type_id] as? Int {
            user.set_user_type_id(val: "\(type_id)")
        }
        /*
         if let type_value =  self.userInfo[Users.userProfileKey.key._type_value] as? String {
         user.set_user_type_value(val:type_value )
         }
         */
        // save users in shared instance
        UserModel.saveUserInfo(user: user)
        // remove indicator
        self.phoneNumberVC_loader.removeFromSuperview()
        
        if user.get_user_type_id() == "1" {
            guard UserInfo.getBy(key: "isDone") is String else {
                OpenViewController.openWith(controller_name: "GuideVC")
                return
            }
        }
        // open view controller
        OpenViewController.openWith(controller_name: "RequestVC")
        
        
        
    }
    
    
    @IBAction func dismissPhoneNumber(_ sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    @objc private func handelRecentCodeAgain(){
        
        if self.verificationCodeCounterCountDown > 0 {
            self.verificationCodeCounterCountDown = self.verificationCodeCounterCountDown - 1
            self.verifiectionCode_lbl_counDown.text = "\(self.verificationCodeCounterCountDown)"
            self.verificationCode_indicator.alpha = 1
            self.verificationCode_indicator.startAnimating()
            self.verifictionCode_btn_recentCode.isEnabled = false
            self.verifictionCode_btn_recentCode.setTitleColor(.gray, for: .normal)
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handelRecentCodeAgain), userInfo: nil, repeats: false)
            return
            
        }
        
        self.verifictionCode_btn_recentCode.isEnabled = true
        self.verifictionCode_btn_recentCode.setTitleColor(.white, for: .normal)
        self.verificationCodeCounterCountDown =  60
        self.verificationCode_indicator.stopAnimating()
        self.verificationCode_indicator.alpha = 0
        self.verifiectionCode_lbl_counDown.text = ""
        
    }
    
    //TODO: Timer Count Down
    var verificationCodeCounterCountDown = 60;
    
    @IBOutlet weak var verificationCode_indicator: UIActivityIndicatorView!{
        didSet{
            self.verificationCode_indicator.stopAnimating()
        }
    }
    @IBOutlet weak var verifiectionCode_lbl_counDown: UILabel!
    @IBOutlet weak var verifictionCode_btn_recentCode: UIButton!{
        didSet{
            self.verifictionCode_btn_recentCode.isEnabled = false
            self.verifictionCode_btn_recentCode.setTitleColor(.gray, for: .normal)
        }
    }
    
}

extension PhoneNumberVerificationViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let codeCount = textField.text?.count else{
            return false
        }
        print(range)
        if codeCount > 5 {
            // DISMISS KEYBOARD
            self.view.endEditing(true)
            textField.becomeFirstResponder()
            self.phoneNumberVerivicationCodeSubmit(UIButton())
        }
        
        return true

    }
    
}

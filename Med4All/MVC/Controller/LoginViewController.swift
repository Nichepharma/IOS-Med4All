//
//  LoginViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginViewController: UIViewController , UITextFieldDelegate {
    private let login_loader = _Indicator()

    private var activeField: UITextField = UITextField()

    @IBOutlet weak var login_txt_email: UITextField!
    @IBOutlet weak var login_txt_password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        login_txt_email.delegate = self
        login_txt_password.delegate = self

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    //Calls this function when the tap is recognized.
    @objc private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)       
    }

   @objc private func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

            if (self.activeField.frame.origin.y) >= keyboardSize.height {
                self.view.frame.origin.y = keyboardSize.height - (self.activeField.frame.origin.y)
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }
   @objc private func keyboardWillHide(_ notification:Notification) {

        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           self.view.frame.origin.y = 0
        }
    }

    @IBAction func login_checkAuth(_ sender: Any) {
        guard  let email = self.login_txt_email.text else{
            return
        }
        guard let password = self.login_txt_password.text else{
            return
        }

        if email.count == 0 {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_EMAIL ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if password.count == 0 {
          _ = _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                            str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_PASSWORD ,
                            str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)

            return
        }
        /*
        if !email.isValidEmail() {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.EMAIL_FORMAT ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        */

        
        // ADD INDICATOR
        self.view.addSubview(login_loader)
        // DISMISS KEYBOARD
        self.view.endEditing(true)
        // CALLING SERVER
        UserModel.userAuthentication(u_email: email, u_password: password, Result: {
            result in
//            print(result)
            if result is Bool {
                _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleWorng ,
                               str_msg: VarConfig.Alert_msgIdentifier.loginError ,
                               str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                self.login_loader.removeFromSuperview()
                return
            }
            if let userDic = result as? [String : Any]{
                let user = Users()
                guard let uID = userDic[Users.userProfileKey.key._u_id] as? String else { return }
                user.setUID(val:uID)
                
                if let f_name = userDic[Users.userProfileKey.key._f_name] as? String{
                    user.set_user_f_name(val: f_name )
                }
                if let l_name = userDic[Users.userProfileKey.key._l_name] as? String{
                    user.set_user_l_name(val: l_name )
                }
                if let phone = userDic[Users.userProfileKey.key._phone] as? String {
                    user.set_user_phone(val:phone)
                }
                if let email = userDic[Users.userProfileKey.key._email] as? String {
                    user.set_user_email(val:email )
                }
                if let country_id = userDic[Users.userProfileKey.key._country_id] as? String  {
                    user.set_user_country_id(val:country_id)
                }
                if let country_name = userDic[Users.userProfileKey.key._country_name] as? String {
                    user.set_user_country_name(val:country_name)
                }
                if let city_id = userDic[Users.userProfileKey.key._city_id] as? String {
                    user.set_user_city_id(val:city_id )
                }
                if let city_name = userDic[Users.userProfileKey.key._city_name] as? String {
                    user.set_user_city_name(val:city_name )
                }
                if let area_id = userDic[Users.userProfileKey.key._area_id] as? String {
                    user.set_user_area_id(val:area_id )
                }
                if let area_name = userDic[Users.userProfileKey.key._area_name] as? String {
                    user.set_user_area_name(val:area_name )
                }
                if let address =  userDic[Users.userProfileKey.key._address] as? String {
                    user.set_user_address(val:address )
                }
                if let type_id =  userDic[Users.userProfileKey.key._type_id] as? String {
                    user.set_user_type_id(val: type_id)
                }
                if let type_value =  userDic[Users.userProfileKey.key._type_value] as? String {
                    user.set_user_type_value(val:type_value )
                }
                // save users in shared instance
                UserModel.saveUserInfo(user: user)
                // remove indicator
                self.login_loader.removeFromSuperview()
                
//                if user.get_user_type_id() == "1"{
//                    guard UserInfo.getBy(key: "isDone") is String else {
//                      OpenViewController.openWith(controller_name: "GuideVC")
//                        return
//                    }
//                }
                    // open view controller
                    OpenViewController.openWith(controller_name: "RequestVC")


                }
        })
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField.returnKeyType == .next {
            self.login_txt_password.becomeFirstResponder()
            return false
        }
        if textField.returnKeyType == .go {
            login_checkAuth( UIButton() )
           textField.endEditing(false)

            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }

 


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

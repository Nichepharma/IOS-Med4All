//
//  SignUpViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate {
    private let signUp_loader = _Indicator()
    private var keyboardIsOpen = false

    private var textActiveSize : CGPoint = CGPoint(x: 0, y: 0)

    @IBOutlet weak var signUp_scrollView: UIScrollView!
    @IBOutlet weak var reg_txt_user_f_name: UITextField!
    @IBOutlet weak var reg_txt_user_l_name: UITextField!
    @IBOutlet weak var reg_txt_user_phone: UITextField!
    @IBOutlet weak var reg_txt_user_email: UITextField!
    @IBOutlet weak var reg_txt_user_password: UITextField!
    @IBOutlet weak var reg_txt_user_address: UITextView!
    @IBOutlet weak var reg_user_type: UISegmentedControl!
    @IBOutlet weak var reg_btn_user_city: UIButton!
    @IBOutlet weak var reg_btn_user_area: UIButton!

    private static var reg_f_name : String = ""
    private static var reg_l_name : String = ""
    private static var reg_phone  : String = ""
    private static var reg_mail   : String = ""
    private static var reg_pass   : String = ""
    private static var reg_address   : String = ""
    private static var reg_userType : Int = 1
    private var cityID  = 0 ;
    private var cityName   : String = ""
    private var areaID  = 0 ;
    private var areaName   : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // DISMISS KEYBOARD
        self.view.endEditing(true)

        reg_txt_user_f_name.text   = SignUpViewController.reg_f_name
        reg_txt_user_l_name.text   = SignUpViewController.reg_l_name
        reg_txt_user_phone.text    = SignUpViewController.reg_phone
        reg_txt_user_email.text    = SignUpViewController.reg_mail
        reg_txt_user_password.text = SignUpViewController.reg_pass
        reg_txt_user_address.text  = SignUpViewController.reg_address

        
        if  StaticVar.locationDataSetter.count > 0 {

            if let cID = StaticVar.locationDataSetter["city_id"] as? Int {
                cityID = cID
            }
            if let cName = StaticVar.locationDataSetter["city_name"] as? String {
                cityName = cName
            }
            if let aID = StaticVar.locationDataSetter["area_id"] as? Int {
                areaID = aID
            }
            if let aName = StaticVar.locationDataSetter["area_name"] as? String {
                areaName = aName
            }

            reg_btn_user_city.setTitle(cityName, for: .normal)
            reg_btn_user_area.setTitle(areaName, for: .normal)

            StaticVar.locationDataSetter.removeAll()

        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    //Calls this function when the tap is recognized.
   @objc private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        keyboardIsOpen = false
    }
    @objc private func keyboardWillShow(_ notification:Notification) {
        if keyboardIsOpen == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.size.height -= keyboardSize.height
                self.view.frame.origin.y = 0
            }
            keyboardIsOpen = true
        }

    }
    @objc private func keyboardWillHide(_ notification:Notification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height = (UIScreen.screens.first?.bounds.height)!
            self.view.frame.origin.y = 0
            keyboardIsOpen = false
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SignUpViewController.reg_f_name   = reg_txt_user_f_name.text!
        SignUpViewController.reg_l_name   = reg_txt_user_l_name.text!
        SignUpViewController.reg_phone    = reg_txt_user_phone.text!
        SignUpViewController.reg_mail     = reg_txt_user_email.text!
        SignUpViewController.reg_pass     = reg_txt_user_password.text!
        SignUpViewController.reg_address  = reg_txt_user_address.text!
        SignUpViewController.reg_userType = reg_user_type.selectedSegmentIndex
        // DISMISS KEYBOARD
        self.view.endEditing(true)
    }
    @IBAction func reg_selectCity(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CityVC") as! CityViewController
            vc.comeFromVC = "RegistrationVC"
        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func reg_selectArea(_ sender: Any) {
        if self.cityID == 0 {
           _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                          str_msg:  VarConfig.Alert_msgIdentifier.SELECT_CITY_FIRIST    ,
                          str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AreaVC") as! AreaViewController
            vc.backToVC = "RegistrationVC"
            vc.city_id = self.cityID
            vc.city_name = self.cityName
        self.present(vc, animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textActiveSize.y = textView.frame.origin.y
        if self.view.frame.height < self.signUp_scrollView.contentSize.height {
            self.signUp_scrollView.contentOffset =  self.textActiveSize
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textActiveSize.y = textField.frame.origin.y
        if self.view.frame.height < self.signUp_scrollView.contentSize.height  {
         self.signUp_scrollView.contentOffset =  self.textActiveSize
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            switch textField {
            case self.reg_txt_user_f_name:
                self.reg_txt_user_l_name.becomeFirstResponder()
                break
            case self.reg_txt_user_l_name:
                self.reg_txt_user_phone.becomeFirstResponder()
                break
            case self.reg_txt_user_phone:
                self.reg_txt_user_email.becomeFirstResponder()
                break
            case self.reg_txt_user_email:
                self.reg_txt_user_password.becomeFirstResponder()
                break
            default:
                self.reg_txt_user_address.becomeFirstResponder()
                break
            }
            return false
        }
        if textField.returnKeyType == .send {
            textField.endEditing(false)
            return false
        }
        return true
    }

//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.textActiveSize = textField.frame
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        self.textActiveSize = textView.frame
//    }

    @IBAction func reg_createAccount(_ sender: Any) {

        guard let user_f_name = self.reg_txt_user_f_name.text else { return }
        guard let user_l_name = self.reg_txt_user_l_name.text else { return }
        guard let user_phone = self.reg_txt_user_phone.text else { return }
        guard let user_email = self.reg_txt_user_email.text else { return }
        guard let user_password = self.reg_txt_user_password.text else { return }
        guard let user_address = self.reg_txt_user_address.text else { return }

        guard let user_cityName = self.reg_btn_user_city.titleLabel?.text else { return }
        guard let user_areaName = self.reg_btn_user_area.titleLabel?.text else { return }


        var userType = 1
        if self.reg_user_type.selectedSegmentIndex == 0 {
            userType = 2
        }
        /**
         * if user type equal 1 is donator
         * if user type equal 2 is volunteer
         */


        if user_f_name .count == 0 {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_F_NAME ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if user_l_name .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_L_NAME ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if user_phone .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_PHONE_NUMBER ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if !user_phone.isPhoneNumber {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.PHONE_NUMBER_FORMAT ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if user_email .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_EMAIL ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if !user_email.isValidEmail() {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.EMAIL_FORMAT ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if user_password .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_PASSWORD ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if user_password .count < 6  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.PASSWORD_FORMAT ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        
        if self.cityName .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_CITY ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if self.areaName .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_AREA ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
         if user_address .count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_ADDRESS ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        let email_PhoneCheckedArray = [ Users.userProfileKey.key._email : user_email  ,
                                        Users.userProfileKey.key._phone : user_phone
                                            ]
        // ADD INDICATOR
        self.view.addSubview(self.signUp_loader)
        // DISMISS KEYBOARD
        self.view.endEditing(true)
        UserModel.canCompliteSignUp(userInfo: email_PhoneCheckedArray , ErrorCode: {res in
            self.signUp_loader.removeFromSuperview()
            switch res {
            case 0 :
                let userDic : [String : Any ] = [
                    Users.userProfileKey.key._f_name   : user_f_name   ,
                    Users.userProfileKey.key._l_name   : user_l_name   ,
                    Users.userProfileKey.key._phone    : user_phone    ,
                    Users.userProfileKey.key._email    : user_email    ,
                    Users.userProfileKey.key._password : user_password ,
                    Users.userProfileKey.key._country_id : 1 ,
                    Users.userProfileKey.key._city_id  : self.cityID     ,
                    Users.userProfileKey.key._area_id  : self.areaID     ,
                    Users.userProfileKey.key._city_name  : user_cityName ,
                    Users.userProfileKey.key._area_name  : user_areaName ,
                    Users.userProfileKey.key._address  : user_address  ,
                    Users.userProfileKey.key._type_id  : userType      ,
                    Users.userProfileKey.key._device_token  : StaticVar.deviceToken,
                    ]
                self.performSegue(withIdentifier: "seg_userInfo", sender: userDic)
                break
            case 1:
               _ = _AlertShow(str_title: "", str_msg: VarConfig.Alert_msgIdentifier.emailIsused, str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                break
            case 2:
                  _ = _AlertShow(str_title: "", str_msg: VarConfig.Alert_msgIdentifier.phoneIsUsed , str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                break
            case 3:
                  _ = _AlertShow(str_title: "", str_msg:VarConfig.Alert_msgIdentifier.email_phoneIsUsed, str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                break
            default :
                _ = _AlertShow(str_title: "", str_msg: "حدث خطاء برجاء المحاوله مره اخري", str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
               self.signUp_dismiss(UIButton())
                break
            }


        })
    }
        @IBAction func signUp_dismiss(_ sender: Any) {
        SignUpViewController.cleareData ()
        OpenViewController.openWith(controller_name: "LoginVC")
    }

    static func cleareData ()  {
        SignUpViewController.reg_f_name   = ""
        SignUpViewController.reg_l_name   = ""
        SignUpViewController.reg_phone    = ""
        SignUpViewController.reg_mail     = ""
        SignUpViewController.reg_pass     = ""
        SignUpViewController.reg_address  = ""
        SignUpViewController.reg_userType = 0

    }


     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "seg_userInfo" {
            if let viewController = segue.destination as? PhoneNumberVerificationViewController {
                if let uInfo = sender as? [String : Any]{
                    viewController.userInfo = uInfo
                }
            }
        }

     }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension String  {
    var isPhoneNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil && self.count > 10 && self.count <  15
        }
    }
}





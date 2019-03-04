//
//  UserProfileViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate{
    var userProfile = Users()
    private var keyboardIsOpen = false


    private let userProfile_loader = _Indicator()


    @IBOutlet weak var userProfile_scrollView: UIScrollView!

    @IBOutlet weak var userProfile_txt_f_name: UITextField!
    @IBOutlet weak var userProfile_txt_l_name: UITextField!
    @IBOutlet weak var userProfile_txt_phone: UITextField!
    @IBOutlet weak var userProfile_txt_email: UITextField!
    @IBOutlet weak var userProfile_btn_city: UIButton!
    @IBOutlet weak var userProfile_btn_area: UIButton!
    @IBOutlet weak var userProfile_txt_address: UITextView!
    @IBOutlet weak var userProfile_btn_submitEdit: UIButton!


    private var profile_cityID   = 0
    private var profile_cityName = ""
    private var profile_areaID   = 0
    private var profile_areaName = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInputView()

        if let cityID : String = UserInfo.getBy(key: Users.userProfileKey.key._city_id) as? String {
            self.profile_cityID = Int(cityID)!
        }

        if let areaID : String = UserInfo.getBy(key: Users.userProfileKey.key._area_id) as? String {
            self.profile_areaID = Int(areaID)!
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


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if  StaticVar.locationDataSetter.count > 0 {
            if let cID = StaticVar.locationDataSetter["city_id"] as? Int {
                profile_cityID = cID
            }
            if let cName = StaticVar.locationDataSetter["city_name"] as? String {
                profile_cityName = cName
            }
            if let aID = StaticVar.locationDataSetter["area_id"] as? Int {
                profile_areaID = aID
            }
            if let aName = StaticVar.locationDataSetter["area_name"] as? String {
                profile_areaName = aName
            }
            print("profile_cityName = " , profile_cityName)
            self.userProfile_txt_address.text  = ""
            userProfile_btn_city.setTitle(profile_cityName , for: .normal)
            userProfile_btn_area.setTitle(profile_areaName , for: .normal)
            StaticVar.locationDataSetter.removeAll()

        }


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
    

    

    private func setupInputView (){

        let user_f_name = "\(UserInfo.getBy(key: Users.userProfileKey.key._f_name))"
        let user_l_name = "\(UserInfo.getBy(key: Users.userProfileKey.key._l_name))"
        let user_phone  =  "\(UserInfo.getBy(key: Users.userProfileKey.key._phone))"
        let user_email  = "\(UserInfo.getBy(key: Users.userProfileKey.key._email))"
        let user_city   = UserInfo.getBy(key: Users.userProfileKey.key._city_name) as? String
        let user_area   = UserInfo.getBy(key: Users.userProfileKey.key._area_name) as? String
        let user_address = UserInfo.getBy(key: Users.userProfileKey.key._address) as? String

        self.userProfile_txt_f_name.text        = user_f_name
        self.userProfile_txt_l_name.text        = user_l_name
        self.userProfile_txt_phone.text         = user_phone
        self.userProfile_txt_email.text         = user_email
        self.userProfile_btn_city.setTitle(user_city , for: .normal)
        self.userProfile_btn_area.setTitle(user_area , for: .normal)
        self.userProfile_txt_address.text = user_address

        self.userProfile_txt_f_name.delegate = self
        self.userProfile_txt_l_name.delegate = self
        self.userProfile_txt_phone.delegate = self
        self.userProfile_txt_email.delegate = self
        self.userProfile_txt_address.delegate = self


    }
    @IBAction func userProfile_openCity(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CityVC") as! CityViewController
        vc.comeFromVC = "UserProfileVC"
        self.present(vc, animated: true, completion: nil)
    }


    @IBAction func userProfile_openArea(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AreaVC") as! AreaViewController
        vc.backToVC = "UserProfileVC"
        vc.city_id = self.profile_cityID
        vc.city_name = self.profile_cityName
        self.present(vc, animated: true, completion: nil)
    }


    @IBAction func userProfile_doUpdate(_ sender: Any) {

        guard let f_name = self.userProfile_txt_f_name.text else {return}
        guard let l_name = self.userProfile_txt_l_name.text else {return}
        guard let phone  = self.userProfile_txt_phone.text else {return}
      //  let country_id = 1
        let city_id = profile_cityID
        let area_id = profile_areaID
        let address = self.userProfile_txt_address.text

        if f_name.characters.count == 0 {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_F_NAME ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if l_name.characters.count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_L_NAME ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if phone.characters.count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_PHONE_NUMBER ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if !phone.isPhoneNumber {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.PHONE_NUMBER_FORMAT ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if city_id == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_CITY ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)

            return
        }
        if area_id == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_AREA ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if address?.count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_ADDRESS ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }



        let userDic : [String : Any ] = [
            Users.userProfileKey.key._u_id     : StaticVar.user_id ,
            Users.userProfileKey.key._f_name   : f_name   ,
            Users.userProfileKey.key._l_name   : l_name   ,
            Users.userProfileKey.key._phone    : phone    ,
            //            Users.userProfileKey.key._password : user_password ,
            Users.userProfileKey.key._city_id  : city_id        ,
            Users.userProfileKey.key._area_id  : area_id        ,
            Users.userProfileKey.key._address  : address!  ,
            ]


          // ADD INDICATOR
        self.view.addSubview(self.userProfile_loader)
        // DISMISS KEYBOARD
        self.view.endEditing(true)
        // CALLING SERVER
        UserModel.updateUserProfile(userInfo: userDic, userProfileUpdated: {
            (succ) in
            if succ as Bool == true {

                let user = Users()
                user.set_user_f_name(val: f_name)
                user.set_user_l_name(val: l_name)
                user.set_user_phone(val: phone)
                user.set_user_city_id(val:"\(city_id)")
                user.set_user_city_name(val: self.profile_cityName)
                user.set_user_area_id(val:"\(area_id)")
                user.set_user_area_name(val:self.profile_areaName)
                user.set_user_address(val: address!)
                // save users in shared instance
                UserModel.saveUserInfo(user: user)


                // Create the alert controller
                let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleDone ,
                                                        message: VarConfig.Alert_msgIdentifier.USER_UPDATED_PROFIEL_DONE ,
                                                        preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                             style: UIAlertActionStyle.default) {
                                                UIAlertAction in
                                                // REMOVE INDICATOR
//                                                UIViewController.root().dismiss(animated: true , completion: nil)
                                                // OpenViewController.openWith(controller_name: "RequestVC")
                                                self.userProfile_dismiss(UIButton())
                                                return

                }
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)



           //     OpenViewController.openWith(controller_name: "RequestVC")


            }else{
                _ = _AlertShow.init(str_title : "",
                                    str_msg   : VarConfig.Alert_msgIdentifier.USER_UPDATED_PROFIEL_FAILD ,
                                    str_btn   : VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            }
            self.userProfile_loader.removeFromSuperview()
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func userProfile_dismiss(_ sender: Any) {
//        OpenViewController.openWith(controller_name: "RequestVC")
   //     UIViewController.root().dismiss(animated: true, completion: nil)
        // self.dismiss(animated: true, completion: nil)

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RequestVC") as! RequestViewController
        self.present(newViewController, animated: true, completion: nil)


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

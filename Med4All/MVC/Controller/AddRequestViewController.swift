//
//  AddRequestViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class AddRequestViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate , UIScrollViewDelegate {

    private var textActiveSize : CGPoint = CGPoint(x: 0, y: 0)
    private var keyboardIsOpen = false
    private let addRequest_loader = _Indicator()

    @IBOutlet weak var add_request_scrollView: UIScrollView!
    @IBOutlet weak var add_request_txt_medName: UITextField!
    @IBOutlet weak var add_request_txt_itemCount: UITextField!
    @IBOutlet weak var add_request_stepper: UIStepper!
    @IBOutlet weak var add_request_txt_vistiDate: UITextField!
    @IBOutlet weak var add_request_txt_vistiTime: UITextField!
    @IBOutlet weak var add_request_btn_city: UIButton!
    @IBOutlet weak var add_request_btn_area: UIButton!
    @IBOutlet weak var add_request_txt_addressDetails: UITextView!
    @IBOutlet weak var add_request_txt_note: UITextView!
    @IBOutlet weak var add_request_btn_submit: UIButton!

    private var numberOfItems = 1

    var add_request_user_id = ""
    var add_request_country_id = 1
    var add_request_country_name = ""
    var add_request_city_id = 0
    var add_request_city_name = ""
    var add_request_area_id = 0
    var add_request_area_name = ""
    var add_request_address =  ""

    static var addRequestDic : [Request] = [Request]()
    static var reqDetails_tempArrayData  =  [String : String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentDate =  Date()
        self.add_request_txt_vistiTime.text = currentDate.getCurrentTime()
        self.add_request_txt_vistiDate.text = currentDate.getCurrentDate()

        if let uID : String = UserInfo.getBy(key: Users.userProfileKey.key._u_id) as? String {
            add_request_user_id = uID
        }
        if let countryID : Int = UserInfo.getBy(key: Users.userProfileKey.key._country_id) as? Int {
            add_request_country_id = countryID
        }
        if let countryName : String =  UserInfo.getBy(key: Users.userProfileKey.key._country_name) as? String {
            add_request_country_name = countryName
        }
        if let cityID : String = UserInfo.getBy(key: Users.userProfileKey.key._city_id) as? String {
            add_request_city_id = Int(cityID)!
        }
        if let cityName : String = UserInfo.getBy(key: Users.userProfileKey.key._city_name) as? String {
            add_request_city_name = cityName
        }
        if let areaID : String = UserInfo.getBy(key: Users.userProfileKey.key._area_id) as? String {
            add_request_area_id = Int(areaID)!
        }
        if let areaName : String = UserInfo.getBy(key: Users.userProfileKey.key._area_name) as? String {
            add_request_area_name = areaName
        }
        if let address : String = UserInfo.getBy(key: Users.userProfileKey.key._address) as? String {
            add_request_address = address
        }

        add_request_scrollView    .delegate      = self
        add_request_txt_medName   .delegate      = self
        add_request_txt_itemCount .delegate      = self
        add_request_txt_vistiDate .delegate      = self
        add_request_txt_vistiTime .delegate      = self
        add_request_txt_addressDetails .delegate = self
        add_request_txt_note .delegate           = self

        add_request_scrollView.layer.cornerRadius = 15
        add_request_btn_city.layer.cornerRadius = 10
        add_request_btn_area.layer.cornerRadius = 10
        add_request_stepper.layer.cornerRadius = 10

        add_request_stepper.minimumValue = 1
        add_request_stepper.stepValue = 1
        add_request_stepper.addTarget(self, action: #selector(setCountToItems(sender:)), for: .valueChanged)

        add_request_btn_city.setTitle(self.add_request_city_name, for: .normal)
        add_request_btn_area.setTitle(self.add_request_area_name, for: .normal)
        add_request_txt_addressDetails.text = add_request_address

        add_request_txt_itemCount.text = "\(numberOfItems)"


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
                add_request_city_id = cID
            }
            if let cName = StaticVar.locationDataSetter["city_name"] as? String {
                add_request_city_name = cName
            }
            if let aID = StaticVar.locationDataSetter["area_id"] as? Int {
                add_request_area_id = aID
            }
            if let aName = StaticVar.locationDataSetter["area_name"] as? String {
                add_request_area_name = aName
            }

            add_request_btn_city.setTitle(add_request_city_name, for: .normal)
            add_request_btn_area.setTitle(add_request_area_name, for: .normal)

            StaticVar.locationDataSetter.removeAll()
            
        }

        if AddRequestViewController.reqDetails_tempArrayData.count >  0 {
            if let val =  AddRequestViewController.reqDetails_tempArrayData["med_name"] {
                add_request_txt_medName.text = val
            }
            if let val =  AddRequestViewController.reqDetails_tempArrayData["med_count"] {
                let countNum = Double(val)!
                numberOfItems = Int(countNum)
                self.add_request_stepper.value =  countNum
                add_request_txt_itemCount.text = val
            }
            if let val =  AddRequestViewController.reqDetails_tempArrayData["visit_date"] {
                add_request_txt_vistiDate.text = val
            }
            if let val =  AddRequestViewController.reqDetails_tempArrayData["visit_time"] {
                add_request_txt_vistiTime.text = val
            }
            if let val =  AddRequestViewController.reqDetails_tempArrayData["address"] {
                add_request_txt_addressDetails.text = val
            }
            if let val =  AddRequestViewController.reqDetails_tempArrayData["note"] {
                add_request_txt_note.text = val
            }
            self.add_request_txt_addressDetails.text  = ""


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
    
    @IBAction func addRequest_selectCity(_ sender: Any) {
        self.setTempData()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CityVC") as! CityViewController
            vc.comeFromVC = "AddRequestVC"
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func addRequest_selectArea(_ sender: Any) {
        self.setTempData()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AreaVC") as! AreaViewController
        vc.backToVC = "AddRequestVC"
        vc.city_id = self.add_request_city_id
        vc.city_name = self.add_request_city_name
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func setCountToItems(sender : Any) {
        let value : Int = Int(add_request_stepper.value)

        if (value < 1){
            return;
        }
        add_request_txt_itemCount.text = String(value)
    }

    @IBAction func add_request_submitButtonAction(_ sender: Any) {
        let request = Request()
        if (add_request_txt_medName.text?.characters.count)! == 0 {

            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg: "أسم الدواء",
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if add_request_stepper.value == 0 {

            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg: "أقل كمية يجب ان تكون واحد علي الاقل",
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if   (add_request_txt_vistiDate.text?.characters.count)! == 0   {
            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg: "برجاء تحديد تاريخ الزيارة",
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if  (add_request_txt_vistiTime.text?.characters.count)! == 0  {
            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg: "برجاء تحديد موعد الزياره",
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if add_request_city_name.characters.count == 0 {

            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg:  VarConfig.Alert_msgIdentifier.REQUIRED_CITY,
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if add_request_area_name.characters.count == 0 {

            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg:  VarConfig.Alert_msgIdentifier.REQUIRED_AREA,
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if (add_request_txt_addressDetails.text?.characters.count)! == 0 {

            _ = _AlertShow(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                           str_msg:VarConfig.Alert_msgIdentifier.REQUIRED_ADDRESS,
                           str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
        }

        if request.setRequestDonatorID(val: add_request_user_id) == false{
            return
        }
        if request.setRequestCountryID(val:"\(add_request_country_id)") == false{
            return
        }
        if request.setRequestCityID(val: "\(add_request_city_id)") == false{
            return
        }
        if request.setRequestAreaID(val: "\(add_request_area_id)") == false{
            return
        }
        if request.setRequestAddressDetail(val:self.add_request_txt_addressDetails.text) == false {
            return
        }
        let VisitDateAndTime  = "\(self.add_request_txt_vistiDate.text!) \(self.add_request_txt_vistiTime.text!)"
        if request.setRequestDonatorTimeAvailable(val:VisitDateAndTime) == false{
            return
        }
        if request.setRequestMedicineName(val: self.add_request_txt_medName.text!) == false{
            return
        }
        if request.setRequestItemCount(val: Int(self.add_request_txt_itemCount.text!)!) == false{
            return
        }

        _ = request.setRequestNote(val: self.add_request_txt_note.text!) == false

        self.view.addSubview(self.addRequest_loader)
        AddRequestModel.createNewRequest(requestInfo: request , requestCreated: {
            succ in
            if (succ == true){

                self.addRequest_loader.removeFromSuperview()
                StaticVar.requestDic.removeAll()
                AddRequestViewController.reqDetails_tempArrayData.removeAll()
                
                // Create the alert controller
                let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                                                        message: VarConfig.Alert_msgIdentifier.DATA_SENT ,
                                                        preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                             style: UIAlertActionStyle.default) {
                                                UIAlertAction in
                                                // REMOVE INDICATOR
                                             //   UIViewController.root().presentingViewController?.dismiss(animated: true , completion: nil)
                                                self.addRequest_dismiss(UIButton())
//                                                OpenViewController.openWith(controller_name: "RequestVC")
                                                return

                }
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)




            }else{
                _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                     str_msg:   VarConfig.Alert_msgIdentifier.DATA_NOT_SENT ,
                                     str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                // REMOVE INDICATOR
                self.addRequest_loader.removeFromSuperview()
                return
            }
        })
    }
    
    // MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == add_request_txt_vistiTime {
            let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                datePicker.addTarget(self, action: #selector(datePickerChangedTime(sender:)), for: .valueChanged)
            textField.inputView = datePicker
        }else if textField == add_request_txt_vistiDate{
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date().getMinimumDate()
            datePicker.addTarget(self, action: #selector(datePickerChangedDate(sender:)), for: .valueChanged)
            textField.inputView = datePicker
        }

        self.textActiveSize.y = textField.frame.origin.y
        if self.view.frame.height < self.add_request_scrollView.contentSize.height {
            self.add_request_scrollView.contentOffset =  self.textActiveSize
        }
    }
    func datePickerChangedTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        add_request_txt_vistiTime.text = formatter.string(from: sender.date)
    }
    func datePickerChangedDate(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        add_request_txt_vistiDate.text = formatter.string(from: sender.date)
    }
    @IBAction func addRequest_dismiss(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RequestVC") as! RequestViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func textViewDidBeginEditing(_ textView: UITextView) {

        self.textActiveSize.y = textView.frame.origin.y
        if self.view.frame.height < self.add_request_scrollView.contentSize.height {
            self.add_request_scrollView.contentOffset =  self.textActiveSize
        }
    }


    func setTempData ()  {
        AddRequestViewController.reqDetails_tempArrayData = ["med_name" : self.add_request_txt_medName.text!    ,
                                                             "med_count"  : self.add_request_txt_itemCount.text!   ,
                                                             "visit_date" : self.add_request_txt_vistiDate.text!   ,
                                                             "visit_time" : self.add_request_txt_vistiTime.text!   ,
                                                             "address" : self.add_request_txt_addressDetails.text ,
                                                             "note" :   self.add_request_txt_note.text
                                                            ]
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


extension  Date {
    func getMinimumDate()->Date{
        var components = DateComponents()
        components.year = 0
        components.month = 0
        components.day = 0
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        return minDate!
    }


    func getCurrentTime()-> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let currentTime = "\(hour):\(minutes)"
        return currentTime
    }

    func getCurrentDate()-> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let currentDay = "\(year)-\(month)-\(day)"
        return currentDay
    }
    
    
}



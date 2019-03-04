//
//  RequestViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import FirebaseAuth


class RequestViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , MenuDelegate {
    
    private let request_loader = _Indicator()

    @IBOutlet weak var request_lbl_title: UILabel!
    @IBOutlet weak var request_btn_add_newRequest: UIButton!
    fileprivate var requestStatus  = 1
    private var menuView : UIView = {
        let view = MenuView.loadViewFromNib()
        view.frame.origin.x  = (UIScreen.screens.first?.bounds.size.width)!
        return view
    }()
    @IBOutlet weak var request_tableView: UITableView!

    private let refreshController : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "جاري تحميل البيانات")
        if StaticVar.userTypeID == 1 {
            refresh.addTarget(self, action: #selector(getRequestFromServer ) , for: UIControlEvents.valueChanged)
        }
        else
        {
            refresh.addTarget(self, action: #selector(getVolunteerRequest ) , for: UIControlEvents.valueChanged)
        }
        return refresh
        }()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NotificationClass.delegate =  self

        self.view.endEditing(true)
        if StaticVar.userTypeID == 2 {
            self.request_lbl_title.text = "التبرعات"
            self.request_btn_add_newRequest.isHidden = true
            request_tableView.frame.size.height  = self.view.frame.size.height - 60
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let edgePan = UIScreenEdgePanGestureRecognizer(target : self , action : #selector (menuSwipe) )
        edgePan.edges = .left
        self.menuView.addGestureRecognizer(edgePan)

        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(edgePanGesture))
        edgeGestureRecognizer.edges = UIRectEdge.right
        self.view.addGestureRecognizer(edgeGestureRecognizer)

        // init menu delegate
        MenuView.delegate = self

        // then adding menu to screen
        self.view.addSubview(menuView)
        
        // defult status equal 1
        requestStatus =  1
        request_tableView.rowHeight = 220
      
        if #available(iOS 10.0, *) {
            self.request_tableView.refreshControl = self.refreshController
        } else {
            self.request_tableView.addSubview(self.refreshController)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if StaticVar.requestDic.count == 0 {
            switch StaticVar.userTypeID {
            case 2 :
                // Get Volunteer Request from Server
                self.getVolunteerRequest()
                break
            default:
                // get Request from server
                self.getRequestFromServer(requestStatus: requestStatus)
                break
            }
        }
        self.request_tableView.reloadData()
    }
    @IBAction func requestDismiss(_ sender: Any) {
        self.getRequestFromServer(requestStatus: requestStatus)
    }
    //MARK: TABLE VIEW DATA SOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return StaticVar.requestDic.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let index = indexPath.section
        let request = StaticVar.requestDic[index]
        if StaticVar.userTypeID == 2 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "request_VolunteerCustomeCell", for: indexPath) as! volRequestCustomCell
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
          //  cell.backgroundColor = .clear
            let request_id = request.getRequestID()
            var med_name =       "لا يوجد اسم للدواء"
            var display_name = "في انتظار متطوع"

            if let m_name = request.getRequestMedicineName() as? String {
                if m_name.count > 0 {
                    med_name = m_name
                }
            }
            if let vol_f_name = request.getRequestDonator_fName() as? String {
                if vol_f_name.count > 0 {
                    display_name = " " + vol_f_name
                }
            }
            if let vol_l_name = request.getRequestDonator_lName() as? String {
                if vol_l_name.count > 0 {
                    display_name = display_name + " " + vol_l_name
                }
            }


            cell.lbl_medcine_name.text =  med_name ;
            cell.lbl_donator_name.text = display_name
            cell.lbl_address.text = "\(request.getRequestCityName()) - \(request.getRequestAreaName())"
            cell.btn_favourit.tag = index
           
            cell.btn_willGo.tag = index
            cell.btn_willGo.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
            
            if let time =  request.getRequestDate() as? String {
                cell.lblTimeAgo.text = Date_and_Time.calculate(requestTime: time)
            }
            // CHECK IF REQUEST IS A FAVOURIT
            if StaticVar.favouritRequestArray.contains(request_id) {
                cell.btn_favourit.addTarget(self, action: #selector(removeFavouritFromDB), for: .touchUpInside)
                cell.btn_favourit.setImage(#imageLiteral(resourceName: "ic_star_18pt"), for: .normal)
            }else{
                cell.btn_favourit.addTarget(self, action: #selector(setRequestFavourit ), for: .touchUpInside)
                cell.btn_favourit.setImage(#imageLiteral(resourceName: "ic_star_border_18pt"), for: .normal)

            }
      

            return cell

        }else {

           let cell = tableView.dequeueReusableCell(withIdentifier: "request_customeCell", for: indexPath) as! CustomeRequestTableViewCell
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            cell.backgroundColor = .clear

            if let time =  request.getRequestDate() as? String {
                cell.lblTimeAgo.text = Date_and_Time.calculate(requestTime: time)
            }

        var med_name =       "لا يوجد اسم للدواء"
        var display_name = "في انتظار متطوع"

        if let m_name = request.getRequestMedicineName() as? String {
            if m_name.count > 0 {
                med_name = m_name
            }
        }
        if let vol_f_name = request.getRequestVolunteer_f_name() as? String {
            if vol_f_name.count > 0 {
                display_name = " " + vol_f_name
            }
        }
        if let vol_l_name = request.getRequestVolunteer_l_name() as? String {
            if vol_l_name.count > 0 {
                display_name = display_name + " " + vol_l_name
            }
        }
        if let req_state = request.getRequestStatus() as? Int {
            switch req_state {
            case 1:
                cell.statusImage.image = UIImage(named: "ic_state1")
                break
            case 2 :
                cell.statusImage.image = UIImage(named: "ic_state2")
                break
            case 3 :
                cell.statusImage.image = UIImage(named: "ic_state3")
                break
            default:
                break
            }
        }
        cell.medicine_name.text =  med_name ;
        cell.volunteer_name.text = display_name ;

            return cell
     }


    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView()
        view.backgroundColor = .clear
        return view
    }


    //MARK: TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async(execute: {
            let index = indexPath.section
            let req = StaticVar.requestDic[index]
            self.performSegue(withIdentifier: "seq_details", sender: req )
        })


    }

    //TODO: ONLY VOLUNTEER METHOD
    //MARK: ADDING FAVOURIT REQUEST TO DB SQLIGHT
    @IBAction func setRequestFavourit(sender : Any){
        
        if let btn = sender as? UIButton{
            btn.setImage(#imageLiteral(resourceName: "ic_star_18pt"), for: .normal)

            let request = StaticVar.requestDic[btn.tag]
            StaticVar.favouritRequestArray.add(request.getRequestID())
            let requestData = [
                "request_id": request.getRequestID() ,
                Request.RequestKey.key._req_med_name : request.getRequestMedicineName() ,
                Request.RequestKey.key._req_date     : request.getRequestDate() ,
                Request.RequestKey.key._donator_id : request.getRequestDonatorID() ,
                Request.RequestKey.key._donator_f_name : request.getRequestDonator_fName() ,
                Request.RequestKey.key._donator_l_name : request.getRequestDonator_lName() ,
                Request.RequestKey.key._donator_phone : request.getRequestDonator_phone() ,
                Request.RequestKey.key._country_id    : request.getRequestCountryID() ,
                Request.RequestKey.key._country_name   : request.getRequestCountryName() ,
                Request.RequestKey.key._city_id : request.getRequestCityID() ,
                Request.RequestKey.key._city_name : request.getRequestCityName() ,
                Request.RequestKey.key._area_id : request.getRequestAreaID() ,
                Request.RequestKey.key._area_name : request.getRequestAreaName() ,
                Request.RequestKey.key._address_detail : request.getRequestAddressDetail() ,
                Request.RequestKey.key._donator_timeAvailable : request.getRequestDonatorTimeAvailable() ,
                Request.RequestKey.key._item_count : request.getRequestItemCount() ,
                Request.RequestKey.key._req_note : request.getRequestNote() ,
                Request.RequestKey.key._req_status : request.getRequestStatus() ,
            ]

            DBManager.getSharedInstance().addfavouritRequest(requestData)
        }
    }
 
    @IBAction func  removeFavouritFromDB(sender : Any){
        if let btn = sender as? UIButton{
        let request = StaticVar.requestDic[btn.tag]
        if let request_id =  request.getRequestID() as? String {
            let suc = DBManager.getSharedInstance().removeFavouritRequest(request_id)
            if suc {
                StaticVar.favouritRequestArray.remove(request_id)
                btn.setImage(#imageLiteral(resourceName: "ic_star_border_18pt"), for: .normal)
            }
        }
        
        }
    }
    //MARK: ACCEPT REQUEST
    @IBAction func acceptRequest(sender : Any){
 
        if let btn = sender as? UIButton{
            // ADD INDICATOR
            self.view.addSubview(self.request_loader)
            let request = StaticVar.requestDic[btn.tag]
            let requestID  = request.getRequestID()
            let defultNewStatus = 2
            RequestModel.changeRequestStatus(request_id: requestID, request_status: defultNewStatus , didChangedRequestValue: {
                changed in
                if changed as? Bool == true {
                    if let donatorToken = request.getRequestDonator_token() as? String {
                        NotificationMangement.sendNotificationToUser(token: donatorToken, isSend: {
                            suc in
                            print(suc)
                        })

                    }
                    StaticVar.requestDic.remove(at: btn.tag)
                    self.request_tableView.reloadData()
                    _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleDone   ,
                                         str_msg:   VarConfig.Alert_msgIdentifier.DATA_SENT         ,
                                         str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                }
                self.request_loader.removeFromSuperview()
            })
        }
        
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seq_details" {
            let reqDetailsVC = segue.destination as! RequestDetailViewController;
            reqDetailsVC.req_detailsDic = sender as! Request
         
        }
    }

   @objc fileprivate func getVolunteerRequest(){
    self.refreshController.endRefreshing()
        StaticVar.requestDic.removeAll()
        self.request_tableView.reloadData()
        let areaID = UserInfo.getBy(key: Users.userProfileKey.key._area_id)
        // ADD INDICATOR
        self.view.addSubview(self.request_loader)

        RequestModel.getVolunteerRequest(areaID: areaID , requestArray: {
            (result) in
            self.initRequestDicArray(serverRequestDatat: result)
            self.request_loader.removeFromSuperview()

         })
    }
   @objc fileprivate func getRequestFromServer (requestStatus : Int = 1){
        self.refreshController.endRefreshing()
        self.view.addSubview(self.request_loader)
        StaticVar.requestDic.removeAll()
        self.request_tableView.reloadData()


        RequestModel.getNewRequestByUserID(requestStatus:requestStatus ,
                                           requestCreated: {
                                            result in
                                            self.initRequestDicArray(serverRequestDatat: result)
                                            self.request_loader.removeFromSuperview()

        })

    }
    
    func initRequestDicArray(serverRequestDatat : Any){
        if serverRequestDatat is NSArray {
            for r in serverRequestDatat as! NSArray {
//                print(r)
                guard  let req : [String : Any] = r as? [String : Any] else { continue }
                guard let req_id = req[Request.RequestKey.key._req_id] as? String else { continue }
                guard let req_donator_id = req[Request.RequestKey.key._donator_id] as? String else {
                    continue
                }
                guard let req_donator_timeAvailable = req[Request.RequestKey.key._donator_timeAvailable] as? String else {
                    continue
                }
                guard let req_country_id = req[Request.RequestKey.key._country_id] as? String else {
                    continue
                }
                guard let req_country_name = req[Request.RequestKey.key._country_name] as? String else {
                    continue
                }
                guard let req_city_id = req[Request.RequestKey.key._city_id] as? String else {
                    continue
                }
                guard let req_city_name = req[Request.RequestKey.key._city_name] as? String else {
                    continue
                }
                guard let req_area_id = req[Request.RequestKey.key._area_id] as? String else {
                    continue
                }
                guard let req_area_name = req[Request.RequestKey.key._area_name] as? String else {
                    continue
                }
                guard let req_address_detail = req[Request.RequestKey.key._address_detail] as? String else {
                    continue
                }
                guard let req_med_name = req[Request.RequestKey.key._req_med_name] as? String else {
                    continue
                }
                guard let req_item_count = Int((req[Request.RequestKey.key._item_count] as? String)!) else {
                    continue
                }
                guard let req_status = Int((req[Request.RequestKey.key._req_status]  as? String)!) else {
                    continue
                }
                guard let req_note = req[Request.RequestKey.key._req_note] as? String else {
                    continue
                }
                guard let req_date = req[Request.RequestKey.key._req_date] as? String else {
                    continue
                }
                
                var req_volnteer_id    = ""
                var req_volnteer_fName = ""
                var req_volnteer_lName = ""
                var req_volnteer_phone = ""
                var req_volnteer_token = ""
                var req_donator_f_name = ""
                var req_donator_l_name = ""
                var req_donator_phone  = ""
                var req_donator_token  = ""

                if let v_id = req[Request.RequestKey.key._volanteer_id] as? String {
                    req_volnteer_id = v_id
                }
                if let v_fname = req[Request.RequestKey.key._volanteer_f_name] as? String {
                    req_volnteer_fName = v_fname
                }
                if let v_lname = req[Request.RequestKey.key._volanteer_l_name] as? String {
                    req_volnteer_lName = v_lname
                }
                if let v_phone = req[Request.RequestKey.key._volanteer_phone] as? String {
                    req_volnteer_phone = v_phone
                }
                if let v_token = req[Request.RequestKey.key._volanteer_token] as? String {
                    req_volnteer_token = v_token
                }
                if let d_fname = req[Request.RequestKey.key._donator_f_name] as? String {
                    req_donator_f_name = d_fname
                }
                if let d_lname = req[Request.RequestKey.key._donator_l_name] as? String {
                    req_donator_l_name = d_lname
                }
                if let d_phone = req[Request.RequestKey.key._donator_phone] as? String {
                    req_donator_phone = d_phone
                }
                if let d_token = req[Request.RequestKey.key._donator_token] as? String {
                    req_donator_token = d_token
                }
                let r = Request()
                _ = r.setRequestID(val:req_id )
                _ = r.setRequestDonatorID(val:req_donator_id )
                _ = r.setRequestDonator_fName(val:req_donator_f_name )
                _ = r.setRequestDonator_lName(val:req_donator_l_name )
                _ = r.setRequestDonator_phone(val:req_donator_phone)
                _ = r.setRequestDonator_token(val:req_donator_token)
                _ = r.setRequestDonatorTimeAvailable(val:req_donator_timeAvailable )
                _ = r.setRequestCountryID(val:req_country_id )
                _ = r.setRequestCountryName(val:req_country_name )
                _ = r.setRequestCityID(val:req_city_id )
                _ = r.setRequestCityName(val:req_city_name )
                _ = r.setRequestAreaID (val:req_area_id )
                _ = r.setRequestAreaName(val:req_area_name )
                _ = r.setRequestAddressDetail(val:req_address_detail )
                _ = r.setRequestMedicineName(val:req_med_name )
                _ = r.setRequestItemCount(val:req_item_count )
                _ = r.setRequestStatus(val:req_status )
                _ = r.setRequestNote(val:req_note )
                _ = r.setRequestDate(val:req_date )
                _ = r.setRequestVolunteerID(val: req_volnteer_id)
                _ = r.setRequestVolunteer_fName(val: req_volnteer_fName)
                _ = r.setRequestVolunteer_lName(val: req_volnteer_lName)
                _ = r.setRequestVolunteer_phone(val: req_volnteer_phone)
                _ = r.setRequestVolunteer_token(val: req_volnteer_token)

                StaticVar.requestDic.append(r)
                
            } // end for each
           
            self.request_tableView.reloadData()
        } // end check if result variable is array
        
        if StaticVar.requestDic.count == 0 {
            DialogApearView.show(messageApear: "لا توجد طلبات في حسابك")
        }
    }






    //MARK: MENU DELEGATE
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        self.openMenu()
    }
    @IBAction func menuButtonAction(_ sender: Any) {
        self.openMenu()
    }
    private  func openMenu()  {
        UIView.animate (withDuration: 0.5 , delay: 0, options: [.curveEaseIn] ,animations: {
            self.menuView.frame.origin.x = 0
        }, completion:{ finished in
        })
    }
    @IBAction func menuSwipe(_ sender: Any) {
        self.dismissMenu()
    }
    func dismissMenu(){
        UIView.animate (withDuration: 0.5 , delay: 0, options: [.curveEaseIn] ,animations: {
            self.menuView.frame.origin.x  = (UIScreen.screens.first?.bounds.size.width)!
        }, completion:{ finished in })
    }
    
    func didSelectUserProfileFromMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
        self.present(newViewController, animated: true, completion: {
            self.dismissMenu()
        })

        
    }
    func didSelectArchiveFromMenu() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ArchiveVC") as! ArchiveViewController
        self.present(newViewController, animated: true, completion: {
            self.dismissMenu()
        })
    }
    
    func didSelectAboutFromMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutViewController
        self.present(newViewController, animated: true, completion: {
            self.dismissMenu()
        })
    }
    func didSelectLogoutFromMenu() {
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                                                message: "هل تريد تسجيل الخروج ؟" ,
                                                preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                     style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                        
                                        self.dismissMenu()
                                        // GET AREA TO UNSUBSCTIBE TOPIC 
                                        if let area_id = UserInfo.getBy(key: Users.userProfileKey.key._area_id) as? String{
                                            NotificationMangement.unSubscripeTopic(topic: area_id)
                                        }
                                        StaticVar.requestDic.removeAll()
                                        UserInfo().clear_data(myKey: Users.userProfileKey.key._u_id )
                                        UserInfo().clear_data(myKey: Users.userProfileKey.key._type_id)
                                        UserInfo.clearAllInfo()
                                        DBManager.getSharedInstance().removeFavouritAllRequest()
                                        StaticVar.favouritRequestArray.removeAllObjects()
                                        UserInfo().setValue("true", forKey: "isDone")
                                        
                                        let firebaseAuth = Auth.auth()
                                        do {
                                            try firebaseAuth.signOut()
                                        } catch let signOutError as NSError {
                                            print ("Error signing out: %@", signOutError)
                                        }
                                        
                                        
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashScreen
                                        self.present(newViewController, animated: true, completion: {
                                            self.dismissMenu()
                                        })

        }
        let cancelAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.CANCEL , style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    func didSelectFavourit() {
        self.dismissMenu()
        OpenViewController.openWith(controller_name: "FavouritVC")
    }
    func didSelectVolunteerGoTo() {
        self.dismissMenu()

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let archiveVC = storyBoard.instantiateViewController(withIdentifier: "ArchiveVC") as! ArchiveViewController
            ArchiveViewController.requestArchivetStatus = 2
        self.present(archiveVC, animated:true, completion:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension RequestViewController : NotificationDelegate {
    func didRecivedNotification() {

            switch StaticVar.userTypeID {
            case 2 :
                // Get Volunteer Request from Server
                self.getVolunteerRequest()
                break
            default:
                // get Request from server
                self.getRequestFromServer(requestStatus: requestStatus)
                break
            }

        self.request_tableView.reloadData()

    }
}

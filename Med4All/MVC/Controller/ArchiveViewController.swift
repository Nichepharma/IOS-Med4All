//
//  ArchiveViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/23/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class ArchiveViewController : UIViewController , UITableViewDataSource , UITableViewDelegate {

    private let archive_loader = _Indicator()

    @IBOutlet weak var requestArchive_lbl_title: UILabel!
    @IBOutlet weak var requestArchiveTableView: UITableView!
  
    private var requestArchiveDic : [Request] = [Request]()
    static var requestArchivetStatus = 3 ;

    private let refreshController : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "جاري تحميل البيانات")
        if StaticVar.userTypeID == 2 {
            refresh.addTarget(self, action: #selector(getArchiveVolunteerRequest ) , for: UIControlEvents.valueChanged)
        }
        else
        {
            refresh.addTarget(self, action: #selector(getRequestFromServer ) , for: UIControlEvents.valueChanged)
        }
        return refresh
    }()
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationClass.delegate =  self

        //IF USER IS VOLUNTEER
        if StaticVar.userTypeID == 2 {
            if (ArchiveViewController.requestArchivetStatus == 2){
                self.requestArchive_lbl_title.text = "قيد الاستلام"
            }
            self.getArchiveVolunteerRequest()
           
        }
        //IF USER IS DONATOR
        else {
            getRequestFromServer()
        }
        
        if #available(iOS 10.0, *) {
            self.requestArchiveTableView.refreshControl = self.refreshController
        } else {
            self.requestArchiveTableView.addSubview(self.refreshController)
        }
        
        
    }


    //MARK: TABLE VIEW DATA SOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return requestArchiveDic.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCustomCell", for: indexPath) as! CustomArchiveCell
            cell.layer.cornerRadius = 15
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
    
        let index = indexPath.section
        if requestArchiveDic.count <= index {
            return cell 
        }
        let request = requestArchiveDic[index]
        var med_name =       "لا يوجد اسم للدواء"
        var _name = "-"


        if let m_name = request.getRequestMedicineName() as? String {
            if m_name.count > 0 {
                med_name = m_name
            }
        }
        if let time =  request.getRequestDate() as? String {
            cell.lblTimeAgo.text = Date_and_Time.calculate(requestTime: time)
        }

        // IF USER TYPE IS DONATOR WILL GET VOLUNTEER DATA TO DISPLAY IT
        if StaticVar.userTypeID == 1 {
            if let vol_f_name = request.getRequestVolunteer_f_name() as? String {
                if vol_f_name.count > 0 {
                    _name = " " + vol_f_name
                }
            }
            if let vol_l_name = request.getRequestVolunteer_l_name() as? String {
                if vol_l_name.count > 0 {
                    _name = _name + " " + vol_l_name
                }
            }
        }
            // IF USER TYPE IS VOLUNTEER WILL GET DONATOR DATA TO DISPLAY IT
        else  if StaticVar.userTypeID == 2 {

            if let vol_f_name = request.getRequestDonator_fName() as? String {
                if vol_f_name.count > 0 {
                    _name = " " + vol_f_name
                }
            }
            if let vol_l_name = request.getRequestDonator_lName() as? String {
                if vol_l_name.count > 0 {
                    _name = _name + " " + vol_l_name
                }
            }
        }






        if StaticVar.userTypeID == 2 && ArchiveViewController.requestArchivetStatus == 2 {
            cell.archive_btn_finishRequest.tag = index
            cell.archive_btn_finishRequest.addTarget(self, action: #selector(changeRequestStatusToFinsh(sender:)), for: .touchUpInside)
        }else{
            cell.archive_btn_finishRequest.isHidden = true;
            cell.archive_img_requestStatus.isHidden = false
        }
        cell.archive_medName.text =  med_name ;
        cell.archive_volunteerName.text = _name ;

        return cell
    }
    //MARK: TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView()
            view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.section
        let req = self.requestArchiveDic[index]
        performSegue(withIdentifier: "seq_details", sender: req )
        
    }

    //MARK: IF USER TYPE IS VOLUNTEER
    @objc  func getArchiveVolunteerRequest(){
        self.refreshController.endRefreshing()
        self.requestArchiveDic.removeAll()
        //RESQUEST STATUS JUST EQUAL 2 OR 3
        if ArchiveViewController.requestArchivetStatus != 2 {
            if ArchiveViewController.requestArchivetStatus != 3 {
                return
            }
        }
        
        // ADD INDICATOR
        self.view.addSubview(self.archive_loader)
        // DISMISS KEYBOARD
        self.view.endEditing(true)
        // CALLING SERVER
        RequestModel.getArchiveVolunteerRequest(requestStatus: ArchiveViewController.requestArchivetStatus , requestCreated: {
            (requestDic) in
            self.initArchiveRequestDicArray(result: requestDic)
            self.archive_loader.removeFromSuperview()
        })
    }

    //MARK: IF USER TYPE IS DONATOR
    @objc  func getRequestFromServer (){
        self.refreshController.endRefreshing()
        self.requestArchiveDic.removeAll()
       // self.request_tableView.reloadData()

        // ADD INDICATOR
        self.view.addSubview(self.archive_loader)
        // DISMISS KEYBOARD
        self.view.endEditing(true)
        // CALLING SERVER
        RequestModel.getNewRequestByUserID(requestStatus:ArchiveViewController.requestArchivetStatus ,
                                           requestCreated: {
                                            result in
                                    self.initArchiveRequestDicArray(result: result)
                                    self.archive_loader.removeFromSuperview()

        })
    }

    @IBAction func changeRequestStatusToFinsh(sender : Any){
        if let btn = sender as? UIButton {
            let index = btn.tag
            let request = requestArchiveDic[index]
            let requestID  = request.getRequestID()
            let newStatus = 3
            RequestModel.changeRequestStatus(request_id: requestID, request_status: newStatus , didChangedRequestValue: {
                changed in
                if changed as? Bool == true {
                    if self.requestArchiveDic.count < index{
                        return
                    }
                    self.requestArchiveDic.remove(at: index)
                    self.requestArchiveTableView.reloadData()
                   /* _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleDone   ,
                                         str_msg:   VarConfig.Alert_msgIdentifier.DATA_SENT         ,
                                         str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
 */
                }
            })

        }
    }

    private func initArchiveRequestDicArray (result : Any){
        if result is NSArray {
            for r in result as! NSArray {
                
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

                
                self.requestArchiveDic.append(r)
                
            } // end for each
            self.requestArchiveTableView.reloadData()
        } // end check if result variable is array
        if self.requestArchiveDic.count == 0 {
            DialogApearView.show(messageApear:"لا توجد طلبات مؤرشفه")
        }
        
    }
    @IBAction func archive_dismiss(_ sender: Any) {
            OpenViewController.openWith(controller_name: "RequestVC")
    //    UIViewController.root().dismiss(animated: true, completion: nil)
        ArchiveViewController.requestArchivetStatus = 3
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seq_details" {
            let reqDetailsVC = segue.destination as! RequestDetailViewController;
                reqDetailsVC.req_detailsDic = sender as! Request
                reqDetailsVC.backTo =  "ArchiveVC"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}





extension ArchiveViewController : NotificationDelegate {
    func didRecivedNotification() {

        switch StaticVar.userTypeID {
        case 2 :
            // Get Volunteer Request from Server
            self.getArchiveVolunteerRequest()
            break
        default:
            // get Request from server
            getRequestFromServer()
            break
        }

        self.requestArchiveTableView.reloadData()

    }




}


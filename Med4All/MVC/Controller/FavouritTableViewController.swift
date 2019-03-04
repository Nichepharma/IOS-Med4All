//
//  FavouritTableViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/26/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class FavouritTableViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    private let favourit_loader = _Indicator()
 
    private var favouritDicArray = [Request]()
    @IBOutlet var favouritTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouritTableView.backgroundColor =  .clear

        let favArray = DBManager.getSharedInstance().getFavouritRequest()
        initFavouritRequestDicArray(favouritRequestDatat: favArray!)
        
      
    }



    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return favouritDicArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request_VolunteerCustomeCell",
                                                 for: indexPath) as! volRequestCustomCell
        cell.layer.cornerRadius = 15
        cell.selectionStyle = .none
        let index = indexPath.section
        var med_name =       "لا يوجد اسم للدواء"
        var display_name = "في انتظار متطوع"

        let request = self.favouritDicArray[index]
        if let m_name = request.getRequestMedicineName() as? String {
            if m_name.count > 1 {
                med_name = m_name
            }
        }
        if let vol_f_name = request.getRequestDonator_fName() as? String {
            if vol_f_name.count > 1 {
                display_name = " " + vol_f_name
            }
        }
        if let vol_l_name = request.getRequestDonator_lName() as? String {
            if vol_l_name.count > 1 {
                display_name = display_name + " " + vol_l_name
            }
        }

      if let time =  request.getRequestDate() as? String {
            cell.lblTimeAgo.text = Date_and_Time.calculate(requestTime: time)
        }

        cell.lbl_medcine_name.text =  med_name ;
        cell.lbl_donator_name.text = display_name
        cell.lbl_address.text = "\(request.getRequestCityName()) - \(request.getRequestAreaName())"
        cell.btn_favourit.tag = index
        //     cell.btn_favourit.addTarget(self, action: #selector(setRequestFavourit ), for: .touchUpInside)

        cell.btn_willGo.tag = index
        cell.btn_willGo.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)


        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView()
            view.backgroundColor = .clear
        return view
    }

    // to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    @IBAction func favouritRemoveRequest(_ sender: Any) {

        if let btn = sender as? UIButton{
            self.removeFunction(index: btn.tag)
        }

    }


    // to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let index = indexPath.section
            self.removeFunction(index:index)

//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    private func  removeFunction(index : Int){
        let request = self.favouritDicArray[index]
        if let request_id =  request.getRequestID() as? String {
            let suc = DBManager.getSharedInstance().removeFavouritRequest(request_id)
            if suc {
                StaticVar.favouritRequestArray.remove(request_id)
                self.favouritDicArray.remove(at: index)
                self.favouritTableView.reloadData()
            }
        }

    }
    //MARK: ACCEPT REQUEST
    @IBAction func acceptRequest(sender : Any){
        
        if let btn = sender as? UIButton{
            // ADD INDICATOR
            self.view.addSubview(self.favourit_loader)
            let request = self.favouritDicArray[btn.tag]
            let requestID  = request.getRequestID()
            let defultNewStatus = 2
            RequestModel.changeRequestStatus(request_id: requestID, request_status: defultNewStatus , didChangedRequestValue: {
                changed in
                if changed as? Bool == true {
                    //MARK: REMOVE REQUEST FROM DB IF RETURN IS TRUE
                    self.removeFunction(index: btn.tag)
                    StaticVar.requestDic.removeAll()
                    self.favouritTableView.reloadData()
                    _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleDone   ,
                                         str_msg:   VarConfig.Alert_msgIdentifier.DATA_SENT         ,
                                         str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                }
                self.favourit_loader.removeFromSuperview()
            })
        }
        
    }

    
    
    func initFavouritRequestDicArray(favouritRequestDatat : Any){
        var serverRequestDatat = [NSMutableDictionary]()

        if let arrToGetCount  = (favouritRequestDatat as AnyObject)[((favouritRequestDatat) as AnyObject).allKeys.first!] as? NSArray {
            for i in 0..<arrToGetCount.count{
                let  tempDic  =  NSMutableDictionary()
                for key in ((favouritRequestDatat) as AnyObject).allKeys {
                    if let arrValue = (favouritRequestDatat as AnyObject)[key] as? NSArray {
                        tempDic.setValue(arrValue[i], forKey: key as! String)
                    }
                }
                serverRequestDatat.append(tempDic)
            }
        }


         for r in serverRequestDatat as NSArray {

         guard let req : [String : Any] = r as? [String : Any] else { continue }
         guard let req_id = req["request_id"] as? String else { continue }
         guard let req_donator_id = req[Request.RequestKey.key._donator_id] as? String else { continue }
         guard let req_donator_timeAvailable = req[Request.RequestKey.key._donator_timeAvailable] as? String else { continue }
         guard let req_country_id = req[Request.RequestKey.key._country_id] as? String else { continue }
         guard let req_country_name = req[Request.RequestKey.key._country_name] as? String else { continue }
         guard let req_city_id = req[Request.RequestKey.key._city_id] as? String else { continue }
         guard let req_city_name = req[Request.RequestKey.key._city_name] as? String else { continue }
         guard let req_area_id = req[Request.RequestKey.key._area_id] as? String else { continue }
         guard let req_area_name = req[Request.RequestKey.key._area_name] as? String else { continue }
         guard let req_address_detail = req[Request.RequestKey.key._address_detail] as? String else { continue }
         guard let req_med_name = req[Request.RequestKey.key._req_med_name] as? String else { continue }
         guard let req_item_count = Int((req[Request.RequestKey.key._item_count] as? String)!) else { continue }
         guard let req_status = Int((req[Request.RequestKey.key._req_status]  as? String)!) else { continue }
         guard let req_note = req[Request.RequestKey.key._req_note] as? String else { continue }
         guard let req_date = req[Request.RequestKey.key._req_date] as? String else { continue }


         var req_volnteer_id    = ""
         var req_volnteer_fName = ""
         var req_volnteer_lName = ""
         var req_volnteer_phone = ""
         var req_donator_f_name = ""
         var req_donator_l_name = ""

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
         if let d_fname = req[Request.RequestKey.key._donator_f_name] as? String {
         req_donator_f_name = d_fname
         }
         if let d_lname = req[Request.RequestKey.key._donator_l_name] as? String {
         req_donator_l_name = d_lname
         }
         if let d_phone = req[Request.RequestKey.key._donator_phone] as? String {
         req_volnteer_phone = d_phone
         }

         let r = Request()
         _ = r.setRequestID(val:req_id )
         _ = r.setRequestDonatorID(val:req_donator_id )
         _ = r.setRequestDonator_fName(val:req_donator_f_name )
         _ = r.setRequestDonator_lName(val:req_donator_l_name )
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

         self.favouritDicArray.append(r)
         }// end for each

         self.favouritTableView.reloadData()
        if self.favouritDicArray.count == 0 {
            DialogApearView.show(messageApear: "لا توجد طلبات في حسابك")
        }
    }



    @IBAction func favourit_dismiss(_ sender: Any) {
//        OpenViewController.openWith(controller_name: "RequestVC")
                UIViewController.root().dismiss(animated: true, completion: nil)
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

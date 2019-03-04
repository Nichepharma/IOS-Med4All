//
//  RequestDetailViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class RequestDetailViewController: UIViewController {
    var backTo = "RequestVC"

     private let req_details_loader = _Indicator()
    var req_detailsDic : Request = Request()

    @IBOutlet weak var req_detail_View: UIView!
    @IBOutlet weak var req_detail_lbl_medName: UILabel!
    @IBOutlet weak var req_detail_lbl_itemCount: UILabel!
    @IBOutlet weak var req_detail_lbl_donatorAvailable: UILabel!
    @IBOutlet weak var req_detail_lbl_address: UILabel!
    @IBOutlet weak var req_detail_lbl_addressDetails: UITextView!
    
    @IBOutlet weak var req_detail_lbl_requestNote: UITextView!
    @IBOutlet weak var req_detail_lbl_volunteerName: UILabel!
    @IBOutlet weak var req_detail_lbl_volunteerPhone: UILabel!
    @IBOutlet weak var req_detail_img_status: UIImageView!
    @IBOutlet weak var req_detail_btn_submitAction: UIButton!    
    @IBOutlet weak var req_detail_lbl_nameTitle: UILabel!
    @IBOutlet weak var req_detail_lbl_phoneTitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.req_detail_View.layer.cornerRadius = 15
        self.req_detail_lbl_medName.text = req_detailsDic.getRequestMedicineName() as? String
        self.req_detail_lbl_itemCount.text   = "\(req_detailsDic.getRequestItemCount())"
        self.req_detail_lbl_requestNote.text = "\(req_detailsDic.getRequestNote())"
        if req_detailsDic.getRequestStatus() as? Int == 1 {
            req_detail_img_status.image = UIImage(named: "ic_state1")
        }
        if req_detailsDic.getRequestStatus() as? Int == 2 {
            req_detail_img_status.image = UIImage(named: "ic_state2")
        }
        if req_detailsDic.getRequestStatus() as? Int == 3 {
            req_detail_img_status.image = UIImage(named: "ic_state3")
        }

        self.req_detail_lbl_donatorAvailable.text = req_detailsDic.getRequestDonatorTimeAvailable() as? String
        self.req_detail_lbl_address         .text = "\(req_detailsDic.getRequestCityName()) / \(req_detailsDic.getRequestAreaName())" //\(req_detailsDic.getRequestCountryName()) /
        self.req_detail_lbl_addressDetails  .text = req_detailsDic.getRequestAddressDetail() as? String
        
        if StaticVar.userTypeID == 2 {
            self.req_detail_lbl_volunteerName.text = "\(req_detailsDic.getRequestDonator_fName()) \(req_detailsDic.getRequestDonator_lName())"
            self.req_detail_lbl_volunteerPhone.text =  "\(req_detailsDic.getRequestDonator_phone())"
            req_detail_lbl_nameTitle.text = "إسم المتبرع"
            req_detail_lbl_phoneTitle.text = "تليفون المتبرع"
            
            // IF USER RECIVED MEDICIEN FROM DONATOR AND SET REQUEST EQUAL 3 HIDDEN BUTTON
            if req_detailsDic.getRequestStatus() as? Int == 2 {
                req_detail_btn_submitAction.setTitle("إلغاء الأستلام", for: .normal)
                req_detail_btn_submitAction.addTarget(self,
                                                      action: #selector(volunteer_cancelequest(sender:)) ,
                                                      for: .touchUpInside)
            }
            else if req_detailsDic.getRequestStatus() as? Int == 3 {
                self.req_detail_btn_submitAction.isHidden = true
            }else {
                req_detail_btn_submitAction.setTitle("استلام", for: .normal)
                req_detail_btn_submitAction.backgroundColor = UIColor(red: 123 / 225 , green: 189 / 255 , blue: 66 / 255 , alpha: 1.0)
                req_detail_btn_submitAction.addTarget(self,
                                                      action: #selector(acceptRequest(sender:)) ,
                                                      for: .touchUpInside)
            }

        }
        //IF USER TYPE IS DONATOR
        else  if StaticVar.userTypeID == 1 {
        
            self.req_detail_lbl_volunteerName   .text = "\(req_detailsDic.getRequestVolunteer_f_name() ) \(req_detailsDic.getRequestVolunteer_l_name())"
            self.req_detail_lbl_volunteerPhone  .text = req_detailsDic.getRequestVolunteer_phone() as? String
            
            req_detail_btn_submitAction.addTarget(self,
                                                  action: #selector(donatorDeleteRequest(sender:)) ,
                                                  for: .touchUpInside)
            
            if req_detailsDic.getRequestStatus() as? Int == 3 {
                self.req_detail_btn_submitAction.isHidden = true
            }
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doDiale))
        self.req_detail_lbl_volunteerPhone.isUserInteractionEnabled=true
        self.req_detail_lbl_volunteerPhone.addGestureRecognizer(tapGesture)
    }

    func doDiale() {
        let phone_number : String = self.req_detail_lbl_volunteerPhone.text!
        if  phone_number.isPhoneNumber {
            if let url = NSURL(string: "tel://\(phone_number)") {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    //MARK: ACCEPT REQUEST
    @IBAction func acceptRequest(sender : Any){
        
        if let btn = sender as? UIButton{
                btn.isHidden = true
                let newStatus = 2
                self.changeRequestStatus(newStatus: newStatus)
            if StaticVar.userTypeID == 2 {
                NotificationMangement.sendNotificationToUser(token: self.req_detailsDic.getRequestDonator_token() as! String , isSend: {
                    suc in
                    print(suc)
                })

            }
        }
        
    }
    //MARK: CANCEL REQUEST
    @IBAction func volunteer_cancelequest(sender : Any){
        
        // Create the alert controller
        let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                                                message: "تأكيد إلغاء طلب الأستلام ؟" ,
                                                preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                     style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let btn = sender as? UIButton{
                btn.isHidden = true
                let newStatus = 1
                self.changeRequestStatus(newStatus: newStatus)


                    if let voulnteerToken =  self.req_detailsDic.getRequestDonator_token() as? String {
                        if voulnteerToken != "" {
                            NotificationMangement.sendNotificationToUser(token: voulnteerToken,
                                                                         body: "تم إلغاء طلب الزياره",
                                                                         isSend: {
                                                                         succ in
                            })
                        }

                }



            }
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
    
    private func changeRequestStatus (newStatus : Int){
        self.view.addSubview(req_details_loader)
        let requestID  = req_detailsDic.getRequestID()
        RequestModel.changeRequestStatus(request_id: requestID, request_status: newStatus , didChangedRequestValue: {
            changed in
            self.req_details_loader.removeFromSuperview()
            if changed as? Bool == true {

               // Create the alert controller
               let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                                                       message: "هل انت موافق علي إلغاء الطلب ؟" ,
                                                       preferredStyle: .alert)
               // Create the actions
               let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss,
                                            style: UIAlertActionStyle.default) {
                                             UIAlertAction in
                                             StaticVar.requestDic.removeAll()
                                             self.requestDetails_dismiss(self.req_detail_btn_submitAction)

               }


               // Add the actions
               alertController.addAction(okAction)
               // Present the controller
               self.present(alertController, animated: true, completion: nil)





                
            }
        })
    }
    
    //MARK: DONATOR DELETE REQUEST
    @IBAction func donatorDeleteRequest(sender : Any){
        
        // Create the alert controller
        let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                                                message: "هل انت موافق علي إلغاء الطلب ؟" ,
                                                preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                     style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                        
        self.deleteRequest()
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
    
    private func deleteRequest() {
        self.view.addSubview(req_details_loader)
        let requestID  = req_detailsDic.getRequestID()
        RequestModel.deleteRequest(request_id: requestID, didChangedRequestValue: {
            isDeleted in
             self.req_details_loader.removeFromSuperview()
            if isDeleted as? Bool == true {
                if self.req_detailsDic.getRequestStatus() as? Int == 2 {
                    if let voulnteerToken =  self.req_detailsDic.getRequestVolunteer_token() as? String {
                        if voulnteerToken != "" {
                            NotificationMangement.sendNotificationToUser(token: voulnteerToken,
                                                                         body: "تم الغاء طلب قد وافقت عليه",
                                                                         isSend: {
                                                                            succ in
                            })
                        }
                    }
                }
//                _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleDone   ,
//                                     str_msg:   VarConfig.Alert_msgIdentifier.DATA_SENT         ,
//                                     str_btn:   VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
                 StaticVar.requestDic.removeAll()
                self.requestDetails_dismiss(self.req_detail_btn_submitAction)
            }
            
        })
        
    }

    @IBAction func requestDetails_dismiss(_ sender: Any) {
       OpenViewController.openWith(controller_name: backTo)
//        OpenViewController.openWith(controller_name: backTo)
//        self.dismiss(animated: true , completion: nil)
 //       UIViewController.root().presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "seg_profile" && sender is Users{
     let userProfileVC = segue.destination as! UserProfileViewController;
     userProfileVC.userProfile = sender as! Users
     }
     }
     */
}

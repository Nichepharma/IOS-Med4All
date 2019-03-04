//
//  ForgetPasswordViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/13/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController , UITextFieldDelegate {


    @IBOutlet weak var forgetPassword_txt_email: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
//                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Calls this function when the tap is recognized.
    @objc private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
        }
    }



    @IBAction func forgetPassword_buttonAction(_ sender: Any) {

        let email =  forgetPassword_txt_email.text

        if email?.count == 0  {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.REQUIRED_EMAIL ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }
        if !(email?.isValidEmail())! {
            _ =  _AlertShow.init(str_title: VarConfig.Alert_msgIdentifier.alertTitleAttention,
                                 str_msg: VarConfig.Alert_msgIdentifier.EMAIL_FORMAT ,
                                 str_btn: VarConfig.Alert_msgIdentifier.alertButtonTitleDismiss)
            return
        }

        UserModel.forgetPassword(email: email!, Result: {
            suc in
        
            if suc as! Bool {
                OpenViewController.openWith(controller_name: "LoginVC")
            }else{
                self.emailIs_notValid()

            }
        })

    }
    //MARK: CANCEL REQUEST
    @IBAction func emailIs_notValid(){
        OperationQueue.main.addOperation {

        // Create the alert controller
        let alertController = UIAlertController(title: VarConfig.Alert_msgIdentifier.alertTitleAttention ,
                                                message: "بريد الإليكتروني غير مسجل من قبل هل تريد تسجيل مستخدم جديد ؟" ,
                                                preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                     style: UIAlertActionStyle.default) {
                                         UIAlertAction in
            self.performSegue(withIdentifier: "goToRegistration", sender: nil)

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
}
    @IBAction func forgetPass_dismiss(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .send {
            forgetPassword_buttonAction(UIButton())
            return false
        }
        return false
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

//
//  MenuView.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/22/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
protocol MenuDelegate {

    func dismissMenu()
    func didSelectUserProfileFromMenu()
    func didSelectArchiveFromMenu()
    func didSelectAboutFromMenu()
    func didSelectLogoutFromMenu()
    //TODO: VOLUNTER DELEGATE FUNCTION
    func didSelectFavourit()
    func didSelectVolunteerGoTo()
    
    
}
class MenuView: UIView {

    @IBOutlet weak var menuViewConstrantWidthSize: NSLayoutConstraint!{

        didSet{
            if DeviceInfo.DEVICE_TYPE == "iPad" {
                self.menuViewConstrantWidthSize.constant = 150
            }
        }
    }
    static var delegate : MenuDelegate!
    
    @IBOutlet weak var menuView_lbl_userName: UILabel!
    @IBOutlet weak var menuView_lbl_area: UILabel!
    
    class func loadViewFromNib() -> UIView {
        var xibFileName = "MenuView"
        if StaticVar.userTypeID == 2 {
            xibFileName = "VolunteerMenuView"
        }
        
        let xibView = UINib(nibName: xibFileName ,
                            bundle: nil).instantiate(withOwner: nil,
                                                     options: nil)[0] as! MenuView
        let user_name = "\(UserInfo.getBy(key: Users.userProfileKey.key._f_name)) \(UserInfo.getBy(key: Users.userProfileKey.key._l_name))"
            xibView.frame = (UIScreen.screens.first?.bounds)!
        xibView.menuView_lbl_userName.text = user_name

        guard let city = UserInfo.getBy(key: Users.userProfileKey.key._city_name) as? String  else { return xibView }
        guard let area = UserInfo.getBy(key: Users.userProfileKey.key._area_name) as? String  else { return xibView }

        let location : String = "\(String(describing: city)) -  \(String(describing: area))"
            xibView.menuView_lbl_area.text = location
//            xibView.menuView_lbl_area.text = area

        return xibView
    }

    @IBAction func MenuView_btn_dismiss(_ sender: Any) {
        MenuView.delegate.dismissMenu()
    }
    @IBAction func menuView_btn_userProfile(_ sender: Any) {
        MenuView.delegate.didSelectUserProfileFromMenu()
    }
    @IBAction func menuView_btn_archive(_ sender: Any) {
        MenuView.delegate.didSelectArchiveFromMenu()
    }
    @IBAction func menuView_btn_aboutMed4All(_ sender: Any) {
        MenuView.delegate.didSelectAboutFromMenu()
    }
    @IBAction func menuView_btn_logout(_ sender: Any) {
        MenuView.delegate.didSelectLogoutFromMenu()
    }
    // MARK: VOLUNTEER BUTTON DELEGATE 
    @IBAction func menuView_btn_favourit(_ sender: Any) {
        MenuView.delegate.didSelectFavourit()
    }
    @IBAction func menuView_btn_GoTo(_ sender: Any) {
        MenuView.delegate.didSelectVolunteerGoTo()
    }

}

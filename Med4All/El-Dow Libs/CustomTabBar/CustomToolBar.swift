//
//  CustomTabBar.swift
//  MyBlood
//
//  Created by Yahia El-Dow on 1/26/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
/**
 * # to use CustomeToolBar Follow this Steps

    1- need to copy CustomeToolBar.swift and OpenViewController.swift to your current project

    2- first adding all buttons , will call "addItem()" Method , this method need parametr (toolbar title and image name)

    3- set ViewController Identifier to call "setViewControllerIdentifier()" method , this method need string parametr ViewController Identifier

    4- finalize call setupToolBar() method

* #  _init() is a example Method , descussing how can calling CustomToolBar Function

* # if need creare your UITabBar in Class will remove self._init()  from init body

* ## try to write a documention your code :- http://snshipster.com/swift-documentation/
 */
class CustomToolBar: UITabBar , UITabBarDelegate{

    private static var currentScreenNumber = 0
    private var toolBarItems : [UITabBarItem] = [UITabBarItem]()
    private var viewControllerIdentifierName = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._init()

    }    //[#END FUNCTION#]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._init()

    } //[#END FUNCTION#]

    private func _init(){
        // adding items to array
        self.addItem(title: "Home",    str_image: "ic_home")
        self.addItem(title: "Profile", str_image: "ic_person")
        self.addItem(title: "Guide",   str_image: "ic_description")

        // set view controller identifier
        setViewControllerIdentifier(vCIdentifier:VarConfig.StoryboardIdentifier.patientHomeIdentifier)
        setViewControllerIdentifier(vCIdentifier:VarConfig.StoryboardIdentifier.patientProfileEditIdentifier)
        setViewControllerIdentifier(vCIdentifier:VarConfig.StoryboardIdentifier.patientGuideIdentifier)

        self.setupToolBar()

    } //[#END FUNCTION#]


    // MARK:- Adding Button
    func addItem(title : String , str_image : String ){
        let item = CustomTabBarItem(itemTitle: title ,
                                    itemStrImage: str_image ,
                                    itemTag: toolBarItems.count)

            toolBarItems.append(item)

    } //[#END FUNCTION#]

    // MARK:- Sett View Controller Identifier
    func setViewControllerIdentifier(vCIdentifier : String) {
        viewControllerIdentifierName.append(vCIdentifier)
    } //[#END FUNCTION#]

    //[#END FUNCTION#]
    // MARK:- Setup ToolBar
    func setupToolBar (){
        // set delegation
        super.delegate =  self

        // display button array to ToolBar view
        self.setItems(toolBarItems, animated: true)

    } //[#END FUNCTION#]


    // MARK:- UITabBar Delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        let tag = item.tag
        if tag ==  CustomToolBar.currentScreenNumber{
            return
        }
        CustomToolBar.currentScreenNumber = tag
        // check array capacity
        if viewControllerIdentifierName.count > tag {
        let _VIEWCONTROLLER_NAME  = viewControllerIdentifierName[tag]
                if _VIEWCONTROLLER_NAME != ""{
                    OpenViewController.openWith(controller_name: _VIEWCONTROLLER_NAME)
            }

        }

    }  //[#END FUNCTION#]

}

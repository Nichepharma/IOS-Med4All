//
//  GuideViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 4/5/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var guideImage: UIImageView!
    private var numberOfTaps = 0
    @IBOutlet weak var guideBtnAction: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(guideButtonAction(_:)))
        guideImage.addGestureRecognizer(tap)
        guideImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    
    @IBAction func guideButtonAction(_ sender: Any) {

            switch numberOfTaps {
            case 0:
                guideImage.image = UIImage(named: "sc2.jpg")
                numberOfTaps += 1
                break
            case 1:
                guideImage.image = UIImage(named: "sc3.jpg")
                numberOfTaps += 1
                guideBtnAction.setTitle("إنهاء", for: .normal)
                break
            case 2:
                UserInfo().setValue("true", forKey: "isDone")
                OpenViewController.openWith(controller_name: "RequestVC")
                break
            default:
                break
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

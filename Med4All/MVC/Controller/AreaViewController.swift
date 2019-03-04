//
//  AreaViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/19/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class AreaViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    private let area_loader = _Indicator()

    var city_id = 0 ;
    var city_name = ""
    var areaDic : NSArray   = NSArray()
    @IBOutlet weak var area_tableView: UITableView!
    var backToVC = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        area_tableView.backgroundColor  = .clear
        // ADD INDICATOR
        self.view.addSubview(self.area_loader)
        // CALLING SERVER
        if city_id != 0
        {
            City_AreaModel.getAreas(city_id: city_id,
                                    request:
                {

                    result in

                    if let areas = result as? NSArray
                    {
                        self.areaDic = areas
                        self.area_tableView.reloadData()
                    }
                    self.area_loader.removeFromSuperview()
            })
        }

    }

    //MARK: -TABLE VIEW DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaDic.count
    }

    //MARK: -TABLE VIEW DATA SOURCE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCustomCell", for: indexPath) as! AreaCustomCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        if let areaArea = areaDic.object(at: indexPath.row) as? [String : Any] {
            // city name
            if let area_name = areaArea["name"] as? String {
                cell.lbl_area_name.text = area_name
            }
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var area_id = 0
        var area_name = ""
        if let areaArea = areaDic.object(at: indexPath.row) as? [String : Any] {

            if let a_id = Int(areaArea["id"] as! String) { area_id = a_id }

            if let a_name = areaArea["name"] as? String {
                area_name = a_name
            }

        }
        StaticVar.locationDataSetter = ["city_id" : self.city_id ,
                                        "city_name" :self.city_name ,
                                        "area_id" : area_id ,
                                        "area_name" : area_name
            ] as [String : Any]


      //  print(self.backToVC)
        OpenViewController.openWith(controller_name: backToVC)


    }

    @IBAction func area_dismiss(_ sender: Any) {
        UIViewController.root().dismiss(animated: true, completion: nil)
        /*
        self.dismiss(animated: true,
                     completion:{
                        self.city_id = 0
        })*/

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

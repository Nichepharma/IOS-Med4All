//
//  CityViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/19/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit

class CityViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate {
    private let city_loader = _Indicator()

    @IBOutlet weak var city_tableView: UITableView!

    var cityDic : NSArray = NSArray()
    var comeFromVC = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(comeFromVC)
        city_tableView.backgroundColor = .clear
        // ADD INDICATOR
        self.view.addSubview(self.city_loader)
        // CALLING SERVER
        City_AreaModel.getCities(request: {
            result in
            if let cities = result as? NSArray {
                self.cityDic = cities
                self.city_tableView.reloadData()
                self.city_loader.removeFromSuperview()
            }
            self.city_loader.removeFromSuperview()
        })
    }

    //MARK: -TABLE VIEW DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return cityDic.count
    }

    //MARK: -TABLE VIEW DATA SOURCE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCustomCell", for: indexPath) as! CityCustomCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear

        if let cityData = cityDic.object(at: indexPath.row) as? [String : Any] {
            // city name
            if let city_name = cityData["name"] as? String {
                    cell.lbl_city_name.text = city_name
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // get city Dic
        if let cityData = cityDic.object(at: indexPath.row) as? [String : Any] {
            print(cityData)

            // get city ID from city Dic
                performSegue(withIdentifier: "seg_area", sender: cityData )
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg_area" {
            let areaVC = segue.destination as! AreaViewController;
            if sender is [String : Any]{
                if let cityData = sender as?  [String : Any] {
                areaVC.city_id   = Int(cityData["id"] as! String)!
                areaVC.city_name = cityData["name"] as! String
                areaVC.backToVC = self.comeFromVC
                }
            }
        }
    }

    @IBAction func city_dismiss(_ sender: Any) {

        self.dismiss(animated: true, completion: {
         
        })
    }

}

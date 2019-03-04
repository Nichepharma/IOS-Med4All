//
//  ViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 3/12/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var noInternetNoifiylabel: UILabel!{
        didSet{
      //  self.noInternetNoifiylabel.backgroundColor = .red

        }
    }

    var reachability: Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0


    override func viewDidLoad() {
        super.viewDidLoad()
    _ = NetCheck()

        //        self.noInternetNoifiylabel.frame.size.width = (UIScreen.screens.first?.bounds.size.width)!
//        self.noInternetNoifiylabel.frame.size.height = (UIScreen.screens.first?.bounds.size.height)!  / 15
//        self.noInternetNoifiylabel.frame.origin.x = 0
//        self.noInternetNoifiylabel.frame.origin.y = 0
//        let colors = [UIColor.red.cgColor ,  UIColor.yellow.cgColor]
//        self.noInternetNoifiylabel.setGradienBackground(colors: colors)


        startHost(at: 0)

    }
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 3)
        }
    }


    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
        } else {
            // "No host name"
            reachability = Reachability()
        }
        self.reachability = reachability


        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateLabelColourWhenNotReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        }
    }

    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
           //"Unable to start\nnotifier"
            return
        }
    }

    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        if reachability.connection == .wifi {
           // self.networkStatus.textColor = .green
        } else {
          //  self.networkStatus.textColor = .blue
        }

      //  self.networkStatus.text = "\(reachability.connection)"
    }

    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")

     //   self.networkStatus.textColor = .red

       // self.networkStatus.text = "\(reachability.connection)"
    }


    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability

        if reachability.connection != .none {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }

    deinit {
        stopNotifier()
    }





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func conn(_ sender: Any) {
        UserModel.userAuthentication(u_email: "yahia.eldow@gmail.com", u_password: "123456789", Result: {
                            (result) in
                            print(result) 
        })

    }



}


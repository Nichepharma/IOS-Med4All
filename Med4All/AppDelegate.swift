
import UIKit
import UserNotifications

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

     func checkIfServerTime_haveValue(){
          Date_and_Time.getServerDate(date_and_time:{ res in
               StaticVar.serverDate_and_Time = res
          })
          let sleep  = NSDate(timeIntervalSinceNow: 3) as Date
          RunLoop.current.run(until: sleep)
          if StaticVar.serverDate_and_Time ==  "" {
               RunLoop.current.run(until: sleep)
          }
     }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

       self.checkIfServerTime_haveValue()

        Messaging.messaging().delegate = self
        FirebaseApp.configure()

        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.InstanceIDTokenRefresh , object: nil)
        application.applicationIconBadgeNumber = 0

        connectToFcm()
//        application.unregisterForRemoteNotifications()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UserModel.resetNotificationBadged_number { (succ) in
            if succ {
                application.applicationIconBadgeNumber = 0
            }
        }
        
    }
    
     func applicationWillTerminate(_ application: UIApplication) {
//          application.applicationIconBadgeNumber =  application.applicationIconBadgeNumber + 1
     }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.canHandleNotification(userInfo) {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }

        Messaging.messaging().appDidReceiveMessage(userInfo)

        var notification_title = "" ;
        var notification_body = "" ;
        var registration_id = "" ;

        if let notificationArray =  userInfo["aps"] as? [String : Any] {
            if let notificationContent = notificationArray["alert"] as? [String : Any] {
                print(notificationContent)
                if let title = notificationContent["title"] as? String {
                    notification_title = title
                }
                if let body = notificationContent["body"] as? String {
                    notification_body = body
                }

            }
        }
        if let req_id = userInfo["gcm.notification.request_id"] as? String {
            registration_id = req_id
        }

        if application.applicationState == .active {
            if NotificationClass.delegate != nil {
                NotificationClass.delegate.didRecivedNotification()
            }
            // Create the alert controller
            let alertController = UIAlertController(title: notification_title ,
                                                    message: notification_body ,
                                                    preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.ACCEPTT ,
                                         style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            self.getRequest_andOpenView(request_id: registration_id)

            }
            let cancelAction = UIAlertAction(title: VarConfig.Alert_msgIdentifier.CANCEL , style: UIAlertActionStyle.cancel)
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            OpenViewController.topMostController().present(alertController, animated: true, completion: nil)

        }else{
               application.applicationIconBadgeNumber =  application.applicationIconBadgeNumber + 1

            getRequest_andOpenView(request_id: registration_id )
            completionHandler(UIBackgroundFetchResult.newData)

        }



    }

    private func getRequest_andOpenView(request_id : String) {
        let request = Request()

        RequestModel.getRequestByID(requestID: request_id, requestDic: {
            r in

            guard  let req : [String : Any] = r as? [String : Any] else { return }
            guard let req_id = req[Request.RequestKey.key._req_id] as? String else { return }
            guard let req_donator_id = req[Request.RequestKey.key._donator_id] as? String else {
                return
            }
            guard let req_donator_timeAvailable = req[Request.RequestKey.key._donator_timeAvailable] as? String else {
                return
            }
            guard let req_country_id = req[Request.RequestKey.key._country_id] as? String else {
                return
            }
            guard let req_country_name = req[Request.RequestKey.key._country_name] as? String else {
                return
            }
            guard let req_city_id = req[Request.RequestKey.key._city_id] as? String else {
                return
            }
            guard let req_city_name = req[Request.RequestKey.key._city_name] as? String else {
                return
            }
            guard let req_area_id = req[Request.RequestKey.key._area_id] as? String else {
                return
            }
            guard let req_area_name = req[Request.RequestKey.key._area_name] as? String else {
                return
            }
            guard let req_address_detail = req[Request.RequestKey.key._address_detail] as? String else {
                return
            }
            guard let req_med_name = req[Request.RequestKey.key._req_med_name] as? String else {
                return
            }
            guard let req_item_count = Int((req[Request.RequestKey.key._item_count] as? String)!) else {
                return
            }
            guard let req_status = Int((req[Request.RequestKey.key._req_status]  as? String)!) else {
                return
            }
            guard let req_note = req[Request.RequestKey.key._req_note] as? String else {
                return
            }
            guard let req_date = req[Request.RequestKey.key._req_date] as? String else {
                return
            }

            var req_volnteer_id    = ""
            var req_volnteer_fName = ""
            var req_volnteer_lName = ""
            var req_volnteer_phone = ""
            var req_donator_f_name = ""
            var req_donator_l_name = ""
            var req_donator_phone  = ""

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
                req_donator_phone = d_phone
            }

            _ = request.setRequestID(val:req_id )
            _ = request.setRequestDonatorID(val:req_donator_id )
            _ = request.setRequestDonator_fName(val:req_donator_f_name )
            _ = request.setRequestDonator_lName(val:req_donator_l_name )
            _ = request.setRequestDonator_phone(val:req_donator_phone)
            _ = request.setRequestDonatorTimeAvailable(val:req_donator_timeAvailable )
            _ = request.setRequestCountryID(val:req_country_id )
            _ = request.setRequestCountryName(val:req_country_name )
            _ = request.setRequestCityID(val:req_city_id )
            _ = request.setRequestCityName(val:req_city_name )
            _ = request.setRequestAreaID (val:req_area_id )
            _ = request.setRequestAreaName(val:req_area_name )
            _ = request.setRequestAddressDetail(val:req_address_detail )
            _ = request.setRequestMedicineName(val:req_med_name )
            _ = request.setRequestItemCount(val:req_item_count )
            _ = request.setRequestStatus(val:req_status )
            _ = request.setRequestNote(val:req_note )
            _ = request.setRequestDate(val:req_date )
            _ = request.setRequestVolunteerID(val: req_volnteer_id)
            _ = request.setRequestVolunteer_fName(val: req_volnteer_fName)
            _ = request.setRequestVolunteer_lName(val: req_volnteer_lName)
            _ = request.setRequestVolunteer_phone(val: req_volnteer_phone)

            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "RequestDetailsVC") as? RequestDetailViewController
            vc!.req_detailsDic  = request
            self.window?.rootViewController = vc;
        })


    }


    // [END receive_message]
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            connectToFcm()
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
                Messaging.messaging().subscribe(toTopic: "/topics/general")
                // [END connect_to_fcm]
            }
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
//        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)

    // InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)

    }


    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false 
    }
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        // Change this to your preferred presentation option
        completionHandler([])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler()
    }
}

// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        StaticVar.deviceToken = fcmToken
    }

    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        Messaging.messaging().appDidReceiveMessage(remoteMessage.appData)
        print(remoteMessage.appData)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return true
    }

}
// [END ios_10_data_message_handling]




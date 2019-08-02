//
//  AppDelegate.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/20/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    var dat = ""
    fileprivate let viewActionIdentifier = "VIEW_IDENTIFIER"
    fileprivate let newsCategoryIdentifier = "NEWS_CATEGORY"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
      
//        if UserDefaults.standard.object(forKey: "keyLanguage")  == nil{
//            CheckLanguage.ChangeLanguage(NewLang: "ar")// default language is english
//        }

        let date = Date()
         let calendar = Calendar.current
          let d = calendar.component( .day , from: date)
           let m = calendar.component( .month , from: date)
            let y = calendar.component( .year, from: date)

           self.dat = "\(d)-\(m)-\(y)"
             helper.saveDate(da: dat)
          //print("daaaaaaaaaaate,\(d)")
           // print("neew daaaaattttttttteee, \(d)-\(m)-\(y)")
        if helper.getDate() == dat {
           //  print("visitores sent already")
        } else {
            setVisitors(date: dat)
        }
       
        if UserDefaults.standard.object(forKey: "keyLanuage") == nil {
            CheckLanguage.ChangeLanguage(NewLang: "ar")
        }
        
        
       // if let currentLanguage = Locale.current.languageCode {
//        if General.CurrentLanguage() ==
//           switch currentLanguage {
//            case "ar" :
//                 CheckLanguage.ChangeLanguage(NewLang: "ar")
//            case "en" :
//                 CheckLanguage.ChangeLanguage(NewLang: "en")
//            default :
//                CheckLanguage.ChangeLanguage(NewLang: "ar")
//            }
       // }
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        
        
        // dat = DateFormatter.localizedString(from: NSDate as Date, dateStyle: DateFormatter.Style.full, timeStyle: DateFormatter.Style.none)
     

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .moviePlayback, options: .mixWithOthers)
            try session.setActive(true)
        } catch {}
        
        // 3
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                //self.instanceIDTokenMessage  = result.token
//                helper.setToken(token: result.token)
//                print("Remote InstanceID token: \(result.token)")
//            }
//        }
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        
        
        helper.statusBarBkColor(colr: #colorLiteral(red: 0.737254902, green: 0.03921568627, blue: 0.4392156863, alpha: 1))
        registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        helper.followStaus(status: 1)
        return true
    }
   

    func setVisitors(date:String) {
        let url = URLs.main+"Api/visitors"
        let para:[String:Any] = [
            "day_date":date
           ]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                print(error)
            case.success(let value):
                let js = JSON(value)
                print(js)
                
            }
        }
        
        
        
    }
   

    
    //jj
    
    func ConnectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        
         InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                helper.setToken(token: result.token)
               
            }
        }
        
    }
    
    
    //
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
            // 1
            let viewAction = UNNotificationAction(identifier: self.viewActionIdentifier,
                                                  title: "View",
                                                  options: [.foreground])
            
            // 2
            let newsCategory = UNNotificationCategory(identifier: self.newsCategoryIdentifier,
                                                      actions: [viewAction],
                                                      intentIdentifiers: [],
                                                      options: [])
            // 3
            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
            
            
            
            self.getNotificationSettings()
        }
    }
    
    
    func SetupPushNotification(application: UIApplication) -> () {
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge])
        { (granted, error) in
            if granted{
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }else{
                print("user notification permission :\(String(describing: error?.localizedDescription))")
            }
        }
        
        
    }
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            
            UNUserNotificationCenter.current().delegate = self
            //Messaging.messaging().delegate = self
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
//    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }
    
    
    
    
    
    
   
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        return true
    }
    
    
    
    
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
       // _ = InstanceID.instanceID().token()
      //  print(newToken!)
        ConnectToFCM()
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
         
        
    }
    //2
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote InstanceID token: \(result.token)")
                helper.setToken(token: result.token)

            }
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
    // 1
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    
    
    //
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.DouglasDevlops.BadgeWasUpdated"), object: nil)
    }
    
}


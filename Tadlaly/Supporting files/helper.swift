//
//  helper.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class helper: NSObject {
    
    
    class func restartApp() {
        
    guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if getUserData() == false {
            vc = sb.instantiateInitialViewController()!
        } else {
            vc = sb.instantiateViewController(withIdentifier: "main")
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }
    
    class func saveApiToken(token: String) {
        let def = UserDefaults.standard
        
        def.setValue(token, forKey: "user_id")
        def.synchronize()
        
        restartApp()
        
    }
    
    class func saveSubDepart(subName: String) {
        let def = UserDefaults.standard
        def.setValue(subName, forKey: "sub_name")
        def.synchronize()
    }
    
    class func setUserData(user_id : Int,user_email:String,user_name:String,user_phone:String,user_photo:String,user_city:String,​user_pass: String){
        
        
        
        print("user id from setUserData \(user_id)")
        let def = UserDefaults.standard
        def.setValue(user_id, forKey: "user_id")
        def.setValue(user_city, forKey: "user_city")
        def.setValue(user_email, forKey: "user_email")
        def.setValue(user_name, forKey: "user_name")
        def.setValue(user_phone, forKey: "user_phone")
        def.setValue(user_photo, forKey: "user_photo")
        def.setValue(​user_pass, forKey: "​user_password")
        def.synchronize()
        restartApp()
    }
    
    class func saveMsg(message: String){
        let defa = UserDefaults.standard
        defa.setValue(message, forKey: "message" )
        defa.synchronize()
    }
    
    class func getMsg() -> String {
        let def = UserDefaults.standard
        return (def.object(forKey: "message") as! String)
    }
    
    class func getSubDepart() -> Int {
         let def = UserDefaults.standard
         return (def.object(forKey: "sub_name") as! Int)
        
    }
    
    class func getApiToken() -> Int {
        let def = UserDefaults.standard
        if (def.object(forKey: "user_id") != nil) {
            return (def.object(forKey: "user_id") as! Int)

        }else{
            return 0
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    class func getUserData()->Bool{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_email") as? String) != nil
    }
    
    class func getUserPhone()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_phone") as! String)
    }
    
    class func getData()->Dictionary<String,String>{
        let def = UserDefaults.standard
        let data:[String:String] = [
            "user_email":def.object(forKey: "user_email") as!String ,
            "user_name":def.object(forKey: "user_name")as!String,
            "user_photo":def.object(forKey: "user_photo") as!String,
            //"user_pass":def.object(forKey: "user_pass") as! String
            ]
        return data
    }
    
    class func deletUserDefaults() {
      //  let domain = Bundle.main.bundleIdentifier!
      //  UserDefaults.standard.removePersistentDomain(forName: domain)
        let def = UserDefaults.standard
        def.removeObject(forKey: "user_email")
        def.removeObject(forKey: "user_name")
        def.removeObject(forKey: "user_photo")
        def.removeObject(forKey: "user_id")
        UserDefaults.standard.synchronize()

        restartApp()
        
    }
    
   class func saveInputs(input: String) {
        let defa = UserDefaults.standard
        defa.set(input, forKey: "inputsArray")
        UserDefaults.standard.synchronize()
        
    }
    
    
    class func setToken(token:String){
        let def = UserDefaults.standard
        def.setValue(token, forKey: "token")
    }
    
    class func getToken()->String{
        let def = UserDefaults.standard
        return ((def.object(forKey: "token") as? String)!)
    }
    
    
    
    class func saveDate(da:String) {
        let def  = UserDefaults.standard
         def.set(da, forKey: "da")
       }
    
    class func getDate()->String {
        let de = UserDefaults.standard
         return((de.object(forKey: "da") as? String)!)
    }
    
    
    class func statusBarBkColor(colr: UIColor ) {
        
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {return}
        statusBarView.backgroundColor = colr
        
    }
    
    class func getCurrentDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        
        return dateFormatter.string(from: date)
    }
    
    
    
   class func followStaus(status: Int) {
      let def = UserDefaults.standard
        def.setValue(status, forKey: "status")
          def.synchronize()
    }
    
    class func getfollowStaus() -> Int {
        let def = UserDefaults.standard
       return ((def.object(forKey: "status") as? Int)!)
    }
    
    
    
}

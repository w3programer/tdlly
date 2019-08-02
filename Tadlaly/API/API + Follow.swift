//
//  API + Follow.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 4/2/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension API {
    
    
    class func myFollowers(pageNu:Int,lat:String, lon:String,completion:@escaping(_ error:Error?, _ data:[MyFollowers]?)->Void) {
        
        let url = URLs.myFollow+"\(pageNu)"
        print(url)
        let para:[String:Any] = [
            "user_google_lat":lat,
            "user_google_long":lon
             ]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                    completion(error, nil)
                    print(error)
            case.success(let value):
                let va = JSON(value)
                  print(va)
                guard let dataArr = va["data"].array else{
                    completion(nil, nil)
                    return
                }
                var ads = [MyFollowers]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = MyFollowers.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
          }
       }
    
    
    class func followType (department_id_fk:String,user_id_fk:String,type:String,completion:@escaping(_ error: Error?, _ success: Bool?)->Void) {
        
        let url = URLs.followStatus
        
        print (url)
        
        let para:[String:Any] = [
            "department_id_fk":department_id_fk,
            "user_id_fk":user_id_fk,
            "type":type
             ]
        Alamofire.request(url, method: .post , parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error, nil)
                print(error)
            case.success(let value):
                let js = JSON(value)
                 //  print("follow jsooon",js)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "flow"), object: nil)
               // let su = js["success_follow"].int!
//                if su == 1 {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "flow"), object: nil)
//                    helper.followStaus(status: 1)
//                } else {
//                    helper.followStaus(status: 0)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unflow"), object: nil)
//                }
            }
        }
    }
    
    class func readedAd(adId: Int , userId:Int, status: String, completion:@escaping(_ error:Error, _ success:Bool?)->Void) {
        
        
        let url = URLs.doRead
         print(url)
        let para:[String:Any] = [
            "advertisement_id":adId,
            "user_id_fk":userId,
            "status":status
        ]
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case.failure(_):break
            case.success(let value):
                let js = JSON(value)
                print(js)
            }
        }
    }

    
    class func checkFollow (department_id_fk:String,
                              user_id_fk:String,
                              type:String,
                              completion:@escaping(_ error: Error?, _ success: Bool?)->Void) {
        
        let url = URLs.followStatus
        
        print (url)
        
        let para:[String:Any] = [
            "department_id_fk":department_id_fk,
            "user_id_fk":user_id_fk,
            "type":type
        ]
        Alamofire.request(url, method: .post , parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error, nil)
                print(error)
            case.success(let value):
                let js = JSON(value)
                print("follow jsooon",js)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "flow"), object: nil)
//                let su = js["status_follow"].bool!
//                if su == false {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "flow"), object: nil)
//                    helper.followStaus(status: 1)
//                } else {
//                    helper.followStaus(status: 0)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unflow"), object: nil)
//                }
            }
        }
    }
    
    
}

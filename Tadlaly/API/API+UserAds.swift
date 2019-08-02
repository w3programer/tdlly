//
//  API+UserAds.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import SVProgressHUD

extension API {
    
    
    class func addAde (advertisementTitle: String, mainDepartment: String, subDepartment: String, advertisementPrice: String, advertisementContent: String, advertisementType: String, city: String, phone: String, showPhone: String, googleLong: String, googleLat: String, image: Array<UIImage>, completion: @escaping (_ error: Error?, _ success: Bool)->Void ) {
        
        
        let url = URLs.addAde
        
        let parameters = [
            "advertisement_title": advertisementTitle,
            "main_department": mainDepartment,
            "sub_department": subDepartment,
            "advertisement_content": advertisementContent,
            "advertisement_price": advertisementPrice,
            "advertisement_type": advertisementType,
            "google_lat": googleLat,
            "google_long": googleLong,
            "city": city,
            "phone": phone,
            "show_phone": showPhone
            
            
        ]
        
        
        
        var headers: [String:String]? = nil
        
        
        headers =
            [
                
                "Content-type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
        ]
        
        
        print(headers ?? "no headers")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index,imageData)  in image.enumerated(){
                
                multipartFormData.append(imageData.jpegData(compressionQuality: 0.6)!, withName: "images[]",fileName: "images\(index).jpg", mimeType: "image/jpg")
            }
            
            
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
            }
            
        }, usingThreshold:UInt64.init(),
           to: url,
           method: .post,
           
           headers: headers,
           encodingCompletion: { (result) in
            
            switch result {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Download Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseString(completionHandler: { (response) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segue"), object: nil)

                    print("successs " + response.result.value!)
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: General.stringForKey(key: "adsuc"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                })
                
                break
                
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "plsCchkUrCon"))
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 2.0)
                completion(encodingError, false)
                break
                
            }
        })
    }
    
    

    
    // update my ad needs  in link > { ​id_advertisement​ }
    
    class func updateMyAd(adId:String, main: String, sub: String, title: String, content: String, price: String, type: String, lat: String, lon: String, city: String, phone:String,showPH: String, imgs: Array<UIImage>, completion: @escaping(_ error: Error?,  _ success: Bool)-> Void) {
        
        //let url = URLs.updateMyAd+adId
        
        
        
        let url="http://tdlly.com/Api/UpdateAdvertisement/"+adId
        
        
        
        print("url \(url)")
        
        
        
//
//        print("title is \(title)")
//        print("price is \(price)")
//        print("content is \(content)")
//        print("type is \(type)")
//
//        print("lat is \(lat)")
//        print("lon is \(lon)")
//        print("city is \(city)")
//        print("phone is \(phone)")
//        print("main is \(main)")
//        print("sub is \(sub)")
        print("showPH is \(showPH)")
        
        
        let parameters = [
            
            "advertisement_title": title,
            "main_department": main,
            "sub_department": sub,
            "advertisement_content": content,
            "advertisement_price": price,
            "advertisement_type": type,
            "google_lat": lat,
            "google_long": lon,
            "city": city,
            "phone": phone,
            "show_phone": showPH,
            
            
            ]
        
        
        
        var headers: [String:String]? = nil
        
        
        headers =
                [
                "Content-type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
                ]
        
        
        print(headers ?? "no headers")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index,imageData)  in imgs.enumerated(){
                
                multipartFormData.append(imageData.jpegData(compressionQuality: 0.6)!, withName: "images[]",fileName: "images\(index).jpg", mimeType: "image/jpg")
            }
            
            
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
            }
            
        }, usingThreshold:UInt64.init(),
           to: url,
           method: .post,
           
           headers: headers,
           encodingCompletion: { (result) in
            
            switch result {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Download Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseString(completionHandler: { (response) in
                    print("successs " + response.result.value!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bk"), object: nil)
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: General.stringForKey(key: "adup"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                })
                
                break
                
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "plsCchkUrCon"))
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 2.0)
                completion(encodingError, false)
                break
                
            }
        })
        
    }
    
    
    
//    class func updateMyAd(adId:String, main: String, sub: String, title: String, content: String, price: String, type: String, lat: String, lon: String, city: String, phone:String,showPH: String, imgs: Array<UIImage>, completion: @escaping(_ error: Error?,  _ success: Bool)-> Void) {
//
//        //let url = URLs.updateMyAd+adId
//
//        let url="http://tdlly.com/Api/UpdateAdvertisement/"+adId
//        print("title is \(title)")
//        print("price is \(price)")
//        print("content is \(content)")
//        print("type is \(type)")
//
//        print("lat is \(lat)")
//        print("lon is \(lon)")
//        print("city is \(city)")
//        print("phone is \(phone)")
//        print("main is \(main)")
//        print("sub is \(sub)")
//        print("showPH is \(showPH)")
//       // print("imgs is \(imgs.count)")
//
//
////        print("url upate is \(url)")
////        let imageData = imgs.pngData()
////        let base64String = imageData?.base64EncodedData(options: .lineLength64Characters)
////
//
//
//        var imgString = [Data]()
//
//        for image in imgs {
//            let result = image.pngData()?.base64EncodedData(options: .lineLength64Characters)
//            imgString.append(result!)
//
//        }
//        let parameters = [
//
//            "advertisement_title": title,
//            "main_department": main,
//            "sub_department": sub,
//            "advertisement_content": content,
//            "advertisement_price": price,
//            "advertisement_type": type,
//            "google_lat": lat,
//            "google_long": lon,
//            "city": city,
//            "phone": phone,
//            "show_phone": showPH,
//            "images[]":imgString
//
//            ] as [String: Any]
//
//
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//
//            switch response.result {
//            case .failure(let error):
//                print(error)
//                completion(error, false)
//            case .success(let value):
//                print(value)
//                SVProgressHUD.show(UIImage(named: "cor.png")!, status: " your ad has been updated successfully")
//                SVProgressHUD.setShouldTintImages(false)
//                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
//                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
//                SVProgressHUD.dismiss(withDelay: 2.0)
//
//
//
//            }
//        }
//    }
    
    
    // my current ad     needs in link > {user_id}

    class func myCurAds(pageNo:Int,completion: @escaping(_ error: Error?,_ data:[MyAds]?)->Void ){
        
        //\(helper.getApiToken())
        let url = URLs.myRecAds+"/\(helper.getApiToken())"+"/\(pageNo)"
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
                SVProgressHUD.dismiss()
            case.success(let value):
                let json = JSON(value)
                print(json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [MyAds]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = MyAds.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
            
        }
    }
    
    
    // my old ad       needs in link > {user_id}
    class func myOldAds(pageNo:Int,completion: @escaping(_ error: Error?,_ data:[MyAds]?)->Void ){
        let url = URLs.myLastAds+"\(helper.getApiToken())"+"/\(pageNo)"
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
                SVProgressHUD.dismiss()
            case.success(let value):
                let json = JSON(value)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [MyAds]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = MyAds.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
          }
    }
    //Array<Any>
    
    class func deletAd(reason: String, idsAdvertisement : String , completion: @escaping(_ error: Error?, _ success: Bool)-> Void) {
        
        
        let url = URLs.deletMyAd
        let parameters = [
            "reason": reason,
            "ids_advertisement[]": idsAdvertisement
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,false)
                print(error)
            case.success(let value):
                completion(nil,true)
                print(value)
                let json = JSON(value)
                if (json["success"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: General.stringForKey(key: "Ad deleted"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                
            }
        }
    }
    
    
    class func deletPic(picId: String, completion: @escaping(_ error: Error?, _ success: Bool)-> Void) {
        
        
        let url = "http://tdlly.com/Api/DeletPhoto/\(helper.getApiToken())"+picId
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,false)
                print(error)
            case.success(let value):
                completion(nil,true)
                print(value)
                let json = JSON(value)
                if (json["success_delete"].int == 1) {
                    SVProgressHUD.show(UIImage(named: "cor.png")!, status: " pic deleted ")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
                
            }
        }
    }
    
    
    
    
    
    
}

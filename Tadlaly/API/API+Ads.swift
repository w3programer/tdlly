 //
//  API+GetRequest.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


extension API {
    
    
    class func slidShowCate(completion: @escaping(_ error: Error?, _ data:[SlidShowData]?) ->Void  ) {
        
        Alamofire.request(URLs.slidShow).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
               // print("\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var cates = [SlidShowData]()
                for data in dataArr {
                    if let data = data.dictionary , let result = SlidShowData.init(dict: data) {
                        cates.append(result)
                      //  print("two")
                    }
                }
                completion(nil,cates)
            }
        }
    }
    
    
    class func categoryDep (completion: @escaping(_ error: Error?, _ data: [CategoriesDep]?) -> Void) {
        Alamofire.request(URLs.categoryDep).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case .success(let value):
                let jsonData = JSON(value)
               // print("one",jsonData)
                guard let dataArray = jsonData.array else{
                    completion(nil , nil)
                    return
                }
                var main = [CategoriesDep]()
                for data in dataArray {
                    if let data = data.dictionary , let result = CategoriesDep.init(dict: data) {
                        main.append(result)
                       // print("good")
                    }
                }
                completion(nil, main)
            }
        }
    }
    
    class func categories (completion: @escaping(_ error: Error?, _ data: [CategoryDep]?) -> Void) {
        Alamofire.request(URLs.categoryDep).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case .success(let value):
                let jsonData = JSON(value)
               // print("one",jsonData)
                guard let dataArray = jsonData.array else{
                    completion(nil , nil)
                    return
                }
                var main = [CategoryDep]()
                for data in dataArray {
                    if let data = data.dictionary , let result = CategoryDep.init(dic: data) {
                        main.append(result)
                      //  print("good")
                    }
                }
                completion(nil, main)
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    //Ads
    // url + id + subName
    // need to parse imgs [[String: Any]] for all classes
    
    class func nearSubAds(pageNo:Int,Sub:String, completion: @escaping(_ error: Error?,_ data:[Ad]?)->Void ){
        
        
      //  print("sub\(Sub)")
        //print("URLs.SubNear+Sub \(URLs.SubNear+Sub)")
        let url = URLs.SubNear+Sub+"/ios"
        
       let  urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
         print("url ===== \(url)")
        
        Alamofire.request(urlwithPercentEscapes!, method: .post).responseJSON { (response) in
            
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
               // print("error for subAds",error)
            case.success(let value):
                let json = JSON(value)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                   // let imgData = data["advertisement_image"].arrayObject as! [[String:Any]]
                   // print("images",imgData)
                    // still need to create path with kind any not json
                }
                completion(nil,ads)
            }
        }
    }
    
    
    
    //??   url + subName
    class func nonUserSubAds(pageNo:Int,subName: String, long: String, lati: String, completion: @escaping(_ error: Error?, _ data:[Ad]?)->Void){
        
        let url = URLs.nonSubNear+subName
        
        let parameters = [
            "user_google_long": long,
            "user_google_lat": lati
                       ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result
            {
                 case.failure(let error):
                     completion(error,nil)
                //       print("error for nonuser SubAds",error)
                case.success(let value):
                     let json = JSON(value)
                guard let dataArr = json.array else{
                           completion(nil , nil)
                          return
                          }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
            
        }
    }
   
    
    // url + id
    class func nearAds(pageNo:Int,completion: @escaping(_ error: Error?, _ data:[Ad]?)->Void) {
        
        
       // let urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    //    print("urlwithPercentEscapes \(urlwithPercentEscapes!)")
        
let url = "http://tdlly.com/Api/Advertisements/2/\(helper.getApiToken())/ios"
         print("url \(url)")
        
         //let urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        //    print("urlwithPercentEscapes \(urlwithPercentEscapes!)")
      //  print("urlWith \(urlwithPercentEscapes!)")
        
        Alamofire.request(url, method: .post).responseJSON { (response) in
            
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
              //  print("error for nearAds",error)
            case.success(let value):
                let json = JSON(value)
               // print("near,\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
        }
    }
    /*
    class func nearAds(completion: @escaping(_ error: Error?,_ data:[Ad]?)->Void ){
        let url = URLs.nearAds+"\(helper.getApiToken())"
        let s = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(s!).responseJSON { (response) in
            
            switch response.result
            { 
            case.failure(let error):
                completion(error,nil)
                print("error for nearAds",error)
            case.success(let value):
                let json = JSON(value)
                print("near,\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
        }
    }
    */
    //non users ads
    class func nonUserNearAds(pageNo:Int,long: String, lati: String, completion: @escaping(_ error: Error?, _ data: [Ad]?)->Void){

        let url = URLs.nonUserNearAds
        let parameters = [
            "user_google_long": long,
            "user_google_lat": lati
        ]

          Alamofire.request(url, method: .post, parameters: nil,encoding: URLEncoding.default, headers: nil).responseJSON { (response) in

            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
               // print("error for non user near ads",error)
            case.success(let value):
                let json = JSON(value)
               // print("nonNear,\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let dat = data.dictionary , let result = Ad.init(dic: dat) {
                        ads.append(result)
                        //print("threeData",dat)
                       // print("fourData",result)
                    }
                }
                completion(nil,ads)
            }
        }
    }
    
    
    
    
    //--->freshAds url + id
    class func freshAds(pageNo:Int,completion:@escaping (_ error: Error?, _ data:[Ad]?)->Void){
        //\(helper.getApiToken()
        
        let url = "http://tdlly.com/Api/Advertisements/1/"+"\(helper.getApiToken())/ios"
      //  print("fresh url \(url)")
        Alamofire.request(url, method: .post , encoding: URLEncoding.default , headers: nil).responseJSON { response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
              //  print("error for fresh ads",error)
            case.success(let value):
             //   print(value)
                let json = JSON(value)
               // print("fresh,\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
        }
    }
    
    
    // non user ads
    
    class func nonUserFreshAds(pageNo:Int,long: String, lati: String, completion: @escaping(_ error: Error?, _ data:[Ad]?)->Void){
        
        let url = URLs.nonUserFreshAds
       // print("non user fresh url \(url)")
        let parameters = [
            "user_google_long": long,
            "user_google_lat": lati
        ]
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
              //  print("error nonuser fresh ads",error)
            case.success(let value):
                let json = JSON(value)
                //print("nonFresh,\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
        }
    }
    

    
    class func count(idAdv:String,count: String, completion: @escaping(_ error: Error?, _ success: Bool)->Void) {

        let url = URLs.share+idAdv
        let parameters = ["count": count]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                completion(error,false)
            case.success(let value):
                completion(nil, true)
                //print(value)
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////
    
    //] } اذا مستخدم غیر مسجل یساوى "search_title" ["user_id" { "all"
    //"user_google_lat" "user_google_long"
    
    // need to parse arrayobject for imgs
    class func searchByTitle (searchTitle: String, long: String,lati: String,userId: String,pageNo:Int, completion: @escaping(_ error: Error?,_ data: [Ad]?)-> Void )  {
        
        let url = URLs.searchTiltle
        print(url)
        let parameters: Parameters = [
            "search_title": searchTitle,
            "user_google_lat": lati,
            "user_google_long": long,
            "user_id": "25"
             ]
        Alamofire.request(url, method: .post , parameters: parameters , encoding: URLEncoding.default, headers: nil).responseJSON {  (response) in
           
                switch response.result {
                case.failure(let error):
                    completion(error, nil)
                    print("error at search",error.localizedDescription)
                case.success(let value):
                    let json = JSON(value)
                    print(json)
                    guard let dataArray = json.array else{
                        completion(nil,nil)
                        return
                    }
                    var resultData = [Ad]()
                    for data in dataArray {
                        if let data = data.dictionary , let result = Ad.init(dic: data) {
                            resultData.append(result)
                        }
                    }
                    completion(nil,resultData)
                }
                
            }
        }
    
    
    
    class func getMainCate(lati:String,long:String,id:String,completion: @escaping(_ error: Error?, _ data:[Ad]?)->Void){
        
        let url = "http://tdlly.com/api/maindepartment/\(id)"
        // print("non user fresh url \(url)")
        
        
        let para =
               [
        
                "user_google_lat": lati,
                "user_google_long": long,
                ]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
            //  print("error nonuser fresh ads",error)
            case.success(let value):
                let json = JSON(value)
                print("cateeeeeees,\(json)")
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var ads = [Ad]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Ad.init(dic: data) {
                        ads.append(result)
                    }
                }
                completion(nil,ads)
            }
        }
    }
    
    
    
}




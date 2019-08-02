//
//  MyAds.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 11/22/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON



//"id_advertisement" : "60",
//"advertisement_date" : "  8 ساعات ",
//"advertisement_image" : [
//                     "photo_name": "5b645dd0877b6.jpg"
//                    "id_photo": "665"
//],
//"view_count" : "0",
//"show_phone" : "2",
//"advertisement_title" : "Fggg",
//"google_lat" : "30.498644848118804",
//"advertisement_content" : "Fgyy",
//"advertisement_price" : "22",
//"share_count" : "1",
//"google_long" : "31.05053502657916",
//"city" : "Menoufia",
//"advertisement_type" : "0",
//"advertisement_date_s" : "2018-12-25 09:27",
//"phone" : "+2022355",
//"advertisement_code" : "138"
// "main_image": ""
//"total_items": 10,
//"current_page": 1


class MyAds: NSObject {
    
    
    var phots:[String]=[]
     var Advtitle: String = ""
      var content: String = ""
       var advertisement_price: String = ""
        var advertisement_date: String = ""
         var city: String = ""
          var id_advertisement: String = ""
           var phone: String = ""
           var advertisement_type: String = ""
          var share_count: String = ""
         var advertisement_code: String = ""
        var adId:String = ""
       var share:String = ""
      var mainImg: String = ""
     var pageNo:Int=1
    var totalPages:Int=1
     var link:String = ""
    
    
    // var advertisement_image = []
    
    init?(dic: [String:JSON]) {
        
        
        self.phone = (dic["phone"]?.string)!
        
        guard let imge = dic["main_image"]?.imagePath, !imge.isEmpty else { return nil}
        self.mainImg = imge
        
        guard let title = dic["advertisement_title"]?.string else {return nil }
        self.Advtitle = title
        self.city = (dic["city"]?.string)!
        self.advertisement_price = (dic["advertisement_price"]?.string)!
        guard let advertisement_datee = dic["advertisement_date"]?.string else {return nil }
        self.advertisement_date = advertisement_datee
        if dic["advertisement_content"]?.string != nil {
            self.content = (dic["advertisement_content"]?.string)!
        }
        self.id_advertisement = (dic["id_advertisement"]?.string)!
        self.advertisement_code = (dic["advertisement_code"]?.string)!
        self.adId = (dic["id_advertisement"]?.string)!
        self.share = (dic["share_count"]?.string)!
        guard let fu = dic["advertisement_type"]?.string else {return}
        self.advertisement_type = fu
        
        self.pageNo=((dic["current_page"]?.int)!)
        self.totalPages=(dic["total_page"]!.int!)
        self.link = (dic["share_link"]?.string)!
        let photos=dic["advertisement_image"]?.array
        let url=URLs.image
        for photo in photos! {
            let image=photo["photo_name"].string
            phots.append( url+image!)
       }
   }
}



//
//  MyFollowers.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 4/2/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyFollowers: NSObject {
    
    
    var phots:[String]=[]
     var mainImg: String = ""
      var date: String = ""
       var adeTitle: String = ""
        var adePrice: String = ""
         var city: String = ""
          var phone: String = ""
           var content: String = ""
           var distance: String = ""
          var viewShare: String = ""
         var view_count:String = ""
        var adId: String = ""
       var userId: String = ""
      var userName: String = ""
     var adverId = ""
    var showPhone = ""
     var typ = ""
    var read_status:Bool = false
    
    init?(dic:[String:JSON]) {
        
        guard let imge = dic["main_image"]?.imagePath, !imge.isEmpty else { return nil}
        self.mainImg = imge
        if dic["advertisement_title"]?.string != nil {
            self.adeTitle = (dic["advertisement_title"]?.string)!
        }
        
        self.content = (dic["advertisement_content"]?.string)!
         self.adePrice = (dic["advertisement_price"]?.string)!
          self.city = (dic["city"]?.string)!
        
        if let s = dic["distance"]?.int  {
            self.distance = "\(s)"
        }
        self.date = (dic["advertisement_date"]?.string)!
         self.phone = (dic["phone"]?.string)!
          self.viewShare = (dic["share_count"]?.string)!
           self.adId = (dic["advertisement_code"]?.string)!
            self.userId = (dic["advertisement_user"]?.string)!
             self.userName = (dic["advertisement_owner"]?.string)!
              self.adverId = (dic["id_advertisement"]?.string)!
               self.showPhone = (dic["show_phone"]?.string)!
                self.typ = (dic["advertisement_type"]?.string)!
                 self.view_count = (dic["view_count"]?.string)!
                  self.read_status = (dic["read_status"]?.bool)!
               let photos=dic["advertisement_image"]?.array
                let url=URLs.image
                 for photo in photos! {
                  let image=photo["photo_name"].string
                    phots.append( url+image!)
                   }
                }
    
}

//class gallar{
//    var photo:String?
//}

    



//
//  CategoryDep.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 4/7/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON




class CategoryDep: NSObject {
    
    
    var depName: String = ""
     var depImage: String = ""
      var depId: String = ""
    
       var subName: String = ""
       // var subImage: String = ""
         var subId: String = ""
    
    init?(dic:[String:JSON]) {
        
        guard let image = dic["main_department_image"]?.imagePath, !image.isEmpty else { return nil }
        
        self.depImage = image
        self.depName = (dic["main_department_name"]?.string)!
        self.depId = (dic["main_department_id"]?.string)!
        
        if let dataArr = dic["sub_depart"]?.array  {
            for dataArr in dataArr {
                let id = (dataArr["sub_department_id"].string)!
                 let name = (dataArr["sub_department_name"].string)!
               //   let icon = dataArr["sub_department_image"].string
                
                self.subName = name
                 self.subId = id
                
            }
        }
        
    }

}

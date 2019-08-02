//
//  BankAccounts.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/29/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//


/*
 "account_number" : "448608010970978",
 "account_id" : "1",
 "account_IBAN" : "SA7380000448608010970978",
 "account_bank_name" : "مصرف الرجحى ",
 "account_image" : "2933b9603ad64a4aa457f0a56be9747b.PNG",
 "account_name" : "مؤسس منصة تدللى لتقنية للمعلومات"
 */

import UIKit
import SwiftyJSON


class BankAccounts: NSObject {
    
    var account_name:String = ""
    var account_bank_name :String = ""
    var account_number:String = ""
    var account_image:String = ""
    var account_IBAN:String = ""
    
    
    init?(dic:[String:JSON]) {
        
        guard let imge = dic["account_image"]?.imagePath, !imge.isEmpty else { return nil}
        self.account_image = imge
        
        self.account_bank_name = dic["account_bank_name"]?.object as! String
        self.account_name = (dic["account_name"]?.string)!
        self.account_number = (dic["account_number"]?.string)!
        self.account_IBAN = (dic["account_IBAN"]?.string)!
        
          }
    
    
    
}




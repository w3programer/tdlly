//
//  NavigationController.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 3/26/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit


class NavigationController: UINavigationController {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonFeatures()
    }
    
    func commonFeatures() {
        
        self.navigationBar.barTintColor = #colorLiteral(red: 0.7831638455, green: 0.1431360543, blue: 0.506254971, alpha: 1)
       
        
    }
    

    
    
    
}

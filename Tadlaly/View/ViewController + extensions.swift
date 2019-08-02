//
//  NaviagtionController + extensions.swift
//  Zi Elengaz
//
//  Created by mahmoudhajar on 4/18/19.
//  Copyright © 2019 CreativeShare. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func hideNavigationShadow(viwController: UIViewController) {
        viwController.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    
}

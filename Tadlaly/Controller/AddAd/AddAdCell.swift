//
//  AddAdCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit



class AddAdCell: UICollectionViewCell {
    
    @IBOutlet weak var adImg: UIImageView!
    @IBOutlet weak var removee: UIButton!
    
    
    override func awakeFromNib() {
        self.adImg.layer.cornerRadius = 10.0
        self.adImg.clipsToBounds = true
   
    }
    
 
    
}

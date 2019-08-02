//
//  UpdateMyAdCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher

class UpdateMyAdCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var remo: UIButton!
    
    override func awakeFromNib() {
        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
        
    }
    
//    var pics: MyAds? {
//        didSet {
//            guard let imgs = pics else { return }
//            self.img.kf.indicatorType = .activity
//            for i in imgs.phots {
//                if let url = URL(string: (i) ) {
//                    self.img.kf.setImage(with: url, placeholder: nil, options:[.transition(ImageTransition.fade(0.5))])
//                }
//            }
//
//        }
//    }
    
    
}

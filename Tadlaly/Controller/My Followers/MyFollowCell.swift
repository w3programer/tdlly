//
//  MyFollowCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 4/2/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher

class MyFollowCell: UITableViewCell {

    
    @IBOutlet weak var bgViw: UIView!
    @IBOutlet weak var adImg: UIImageView!
    //@IBOutlet weak var kindLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var cityLab: UILabel!
    @IBOutlet weak var distanceLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          bgViw.floatView()

    }

    var pics: MyFollowers? {
        didSet {
            guard let imgs = pics else { return }
            self.adImg.kf.indicatorType = .activity
            if let url = URL(string: (imgs.mainImg) ) {
                self.adImg.kf.setImage(with: url, options:[.transition(ImageTransition.fade(0.5))])
            }
        }
    }

    
    
    
    
}

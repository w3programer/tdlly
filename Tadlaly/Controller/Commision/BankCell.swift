//
//  BankCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 3/16/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher

class BankCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var accName: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var accNumLab: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var viw: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viw.floatView()
        
        
    }

    var pics: BankAccounts? {
        didSet {
            guard let imgs = pics else { return }
            
            self.img.kf.indicatorType = .activity
            if let url = URL(string: (imgs.account_image)) {
                self.img.kf.setImage(with: url, options:[.transition(ImageTransition.fade(0.5))])
                
            }
        }
    }

}

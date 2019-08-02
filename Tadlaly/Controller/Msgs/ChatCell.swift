//
//  ChatCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/31/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Kingfisher

class ChatCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var msgContent: UILabel!
    @IBOutlet weak var img: CircleImage!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.msgContent.layer.cornerRadius = 10.0
        self.msgContent.clipsToBounds = true
        self.time.layer.cornerRadius = 10.0
        self.time.clipsToBounds = true
        
    }

    
    var pics: Message? {
        didSet {
            guard let imgs = pics else { return }
            
            self.img.kf.indicatorType = .activity
            if let url = URL(string: (imgs.fromImg) ) {
                //                self.img.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
                self.img.kf.setImage(with: url,options:[.transition(ImageTransition.fade(0.5))])
            }
        }
    }
    
    
    
}

//
//  AdCollectionCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class AdCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.subLabel.layer.cornerRadius = 10.0
        self.subLabel.clipsToBounds = true
        
    }

    override var isSelected: Bool {
        didSet {
            if  isSelected {
                self.subLabel.backgroundColor = UIColor.darkGray
                self.subLabel.textColor = UIColor.white
                UIView.animate(withDuration: 0.5) {
                    let scale: CGFloat = 0.9
                    self.transform = self.isSelected ? CGAffineTransform(scaleX: scale, y: scale) : .identity
                }
            } else {
                let bg = #colorLiteral(red: 0.5098039216, green: 0, blue: 0.3176470588, alpha: 0.801369863)
                self.subLabel.backgroundColor = bg
                self.subLabel.textColor = UIColor.white
            }
        }
    }
    

}

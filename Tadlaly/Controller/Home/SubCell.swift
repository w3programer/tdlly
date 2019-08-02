//
//  SubCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 11/13/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit

class SubCell: UICollectionViewCell {
    
    @IBOutlet weak var subNm: UILabel!
    
    override func awakeFromNib() {
        self.subNm.layer.cornerRadius = 10.0
        self.subNm.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
//            UIView.animate(withDuration: 1.0) {
//                let scale: CGFloat = 0.9
//                self.transform = self.isSelected ? CGAffineTransform(scaleX: scale, y: scale) : .identity
//            }
            
            
            UIView.animate(withDuration: 1.0, delay: 1.2, options: .curveEaseOut, animations: {

            }, completion: { finished in
                print("Napkins opened!")
            })

            
        }
    }

    
    
}

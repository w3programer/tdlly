//
//  BankAccountCell.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 3/27/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit

class BankAccountCell: UITableViewCell {

    
    @IBOutlet weak var viw: UIView!
    @IBOutlet weak var bankLab: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var numLab: UILabel!
    @IBOutlet weak var ibanLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.viw.floatView()
        
        
    }

 
}

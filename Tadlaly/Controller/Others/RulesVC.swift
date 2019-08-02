//
//  RulesVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/27/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class RulesVC: UIViewController {

    @IBOutlet weak var txt: UITextView!
    @IBOutlet weak var titl: UILabel!
    @IBOutlet weak var navi: UINavigationBar!
    
    var recMenu = ""
    
        fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
        fileprivate var audioPlayer = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if recMenu == "menu" {
            HomeVC.statusBar()
             self.navi.alpha = 1.0
              self.navi.topItem?.title = General.stringForKey(key: "terms and condtions")
        } else {
            self.navi.alpha = 1.0
            self.navigationItem.title = General.stringForKey(key: "terms and condtions")
        }

        DispatchQueue.main.async {
            self.getRules()
        }
        
        
        self.configDesign()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        
        
    }

    
    
    
    
    
    @IBAction func unwindBtn(_ sender: Any) {
        
     //   audioPlayer.play()
        if recMenu == "menu" {
          performSegue(withIdentifier: "ruleUnwind", sender: self)
        } else {
            performSegue(withIdentifier: "ru", sender: self)
        }
    }
    
    

    
    func getRules() {
        Alamofire.request(URLs.rules).responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                self.titl.text = jsonData["title"].string
                self.txt.text = jsonData["content"].string
            } else{
                print("faild")
            }
        }
    }
    
    func configDesign() {
       self.txt.layer.cornerRadius = 10.0
       self.txt.clipsToBounds = true
       self.txt.layer.shadowColor = UIColor.darkGray.cgColor
       self.txt.layer.shadowRadius = 4
       self.txt.layer.shadowOpacity = 0.8
       self.txt.layer.shadowOffset = CGSize(width: 0, height: 0)
    
       self.titl.layer.cornerRadius = 10.0
       self.titl.clipsToBounds = true
       self.titl.layer.shadowColor = UIColor.darkGray.cgColor
       self.titl.layer.shadowRadius = 4
       self.titl.layer.shadowOpacity = 0.8
       self.titl.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
   

}

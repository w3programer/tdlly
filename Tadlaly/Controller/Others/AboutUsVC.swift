//
//  AboutUsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class AboutUsVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var wna: CornerButtons!
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
 
        self.wna.setTitle(General.stringForKey(key: "wna"), for: .normal)
        
        DispatchQueue.main.async {
    
            self.request()
            
                   }
        
        configdesign()
        
    }

    
    @IBAction func wnaBtn(_ sender: Any) {
        if let url = URL(string: "http://goo.gl/TTNBA7" ) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    func request() {
        Alamofire.request(URLs.aboutUs) .responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                self.text.text = (jsonData["about_app"].object as! String)
            } else {
                print("faild")
            }
        }
    }
    
    
    func configdesign() {
        
        self.img.layer.cornerRadius = 10.0
        self.img.clipsToBounds = true
        self.img.layer.shadowColor = UIColor.darkGray.cgColor
        self.img.layer.shadowOpacity = 0.5
        self.img.layer.shadowRadius = 4
        
        self.text.layer.cornerRadius = 10
        self.text.layer.shadowColor = UIColor.darkGray.cgColor
        self.text.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.text.layer.shadowOpacity = 0.5
        self.text.layer.shadowRadius = 4
        
    }
    
    
    @IBAction func back(_ sender: Any) {
     //   audioPlayer.play()
        //if helper.getUserData() == false {
        performSegue(withIdentifier: "aboutUnwind", sender: self)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    

   

}

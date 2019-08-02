//
//  LaunchScreenVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation



class LaunchScreenVC: UIViewController {

   
    var window: UIWindow?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           loadVideo()
        perform(#selector(move), with: nil, afterDelay: 6.0)
        
        
    
    

        

    }
  

    @objc func move () {
        
        if helper.getUserData() == true{
            let Sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc =   Sb.instantiateViewController(withIdentifier: "main") as! SWRevealViewController
            //self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true,completion: nil)
//            let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
//            self.window?.rootViewController = tab
        } else {
            performSegue(withIdentifier: "go", sender: self)
            print("goooooo")
        }
        
    }
    
    
    
    
    
    
    
    private func loadVideo() {
        var player: AVPlayer?
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
//        } catch { }
        let path = Bundle.main.path(forResource: "Video", ofType:"MOV")
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        player?.seek(to: CMTime.zero)
        player?.play()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackDidFinish), name: .AVPlayerItemDidPlayToEndTime , object: player?.currentItem)
    }
    
    //    @objc func moviePlayBackDidFinish ( _ notification: Notification) {
    //        NotificationCenter.default.removeObserver(self)

    //    }

}








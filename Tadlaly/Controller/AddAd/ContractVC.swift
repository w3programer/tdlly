//
//  ContractVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class ContractVC: UIViewController {
    
    @IBOutlet weak var Seg: UISegmentedControl!
    @IBOutlet weak var segTwo: UISegmentedControl!
    @IBOutlet weak var segTh: UISegmentedControl!
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var SeBtn: CornerButtons!
    @IBOutlet weak var org: UIButton!
    
    
    
    var isSelectedOne = false
    var isSelectedTwo = false
    var isSelectedThree = false
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    var recTitle = ""
    var recMa  = ""
    var recDe = ""
    var recPri = ""
    var recCon = ""
    var recTyp = ""
    var recCity = ""
    var recPh = ""
    var recShPh = ""
    var recLo = ""
    var recLa = ""
    var recImgs = [UIImage]()
    
    
     var strings = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeVC.statusBar()

         setLoca()
     

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.segue), name: NSNotification.Name(rawValue: "segue"), object: nil)


    }
    
    @ objc func segue(notif: NSNotification) {

        self.performSegue(withIdentifier:"unwindC", sender: self)

    }

    
    
    
    @IBAction func segOneBtn(_ sender: Any) {
        audioPlayer.play()
        if Seg.selectedSegmentIndex == 0 {
            self.isSelectedOne = false
        } else {
            self.isSelectedOne = true
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
     //   audioPlayer.play()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func segTwoBtn(_ sender: Any) {
        audioPlayer.play()
        if segTwo.selectedSegmentIndex == 0 {
            self.isSelectedTwo = false
        } else {
            self.isSelectedTwo = true
        }
    }
    
    
    @IBAction func SegThirdBtn(_ sender: Any) {
        audioPlayer.play()
        if segTh.selectedSegmentIndex == 0 {
            self.isSelectedThree = false
        } else {
            self.isSelectedThree = true
        }
    }
    
    
    @IBAction func imgTappedBtn(_ sender: Any) {
        audioPlayer.play()
        if let url = URL(string: URLs.ekhaa ) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func agrementBtn(_ sender: Any) {
        audioPlayer.play()
        audioPlayer.play()
        if let url = URL(string: URLs.ekhaa ) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func SendBtn(_ sender: Any) {
      audioPlayer.play()
        LogInVC.shared.hudStart()
        if isSelectedTwo && isSelectedTwo && isSelectedThree == true {
            
//            print(recTitle)
//            print(recMa)
//            print(recDe)
//            print(recPri)
//            print(recCon)
//            print(recTyp)
//            print(recCity)
//            print(recPh)
//            print( recShPh)
//            print(recLo)
//            print(recLa)
//            print("num of img",strings.count)
            
            
    API.addAde(advertisementTitle: recTitle, mainDepartment: recMa, subDepartment: recDe, advertisementPrice: recPri, advertisementContent: recCon, advertisementType: recTyp, city: recCity, phone: recPh, showPhone: recShPh, googleLong: recLo, googleLat: recLa, image: recImgs) { (error:Error?, success: Bool?) in
        
        if success == true {
            
            print("yeeeah   sucess")
       

            
           } else {
            SVProgressHUD.show(UIImage(named: "noWifi.png")!, status: General.stringForKey(key: "plsCchkUrCon"))
            SVProgressHUD.setShouldTintImages(false)
            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
            SVProgressHUD.dismiss(withDelay: 2.0)
               }
            }
        } else {
            SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "seRu"))
            SVProgressHUD.setShouldTintImages(false)
            SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
            SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
            SVProgressHUD.dismiss(withDelay: 2.5)
        }

    }
    
    func base64(from image: UIImage) -> String? {
        let imageData = image.pngData()
        if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
            return imageString
        }
        return nil
    }
    
    func setLoca() {
        navi.topItem?.title = General.stringForKey(key: "pledge")
        SeBtn.setTitle(General.stringForKey(key: "send"), for: .normal)
        Seg.setTitle(General.stringForKey(key: "disagree"), forSegmentAt: 0)
        Seg.setTitle(General.stringForKey(key: "agree"), forSegmentAt: 1)
        segTwo.setTitle(General.stringForKey(key: "disagree"), forSegmentAt: 0)
        segTwo.setTitle(General.stringForKey(key: "agree"), forSegmentAt: 1)
        segTh.setTitle(General.stringForKey(key: "disagree"), forSegmentAt: 0)
        segTh.setTitle(General.stringForKey(key: "agree"), forSegmentAt: 1)
        org.setTitle("للجمعيه الخيرية لرعاية الايتام إخاء", for: .normal)
    }
    
    
}

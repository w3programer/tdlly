//
//  ContactUsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ContactUsVC: UIViewController {

    @IBOutlet weak var namTF: UITextField!
    @IBOutlet weak var emaiTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var subjecTF: UITextField!
    @IBOutlet weak var msgTf: UITextView!
    @IBOutlet weak var maBtn: UIButton!
    @IBOutlet weak var wtsBtn: UIButton!
    @IBOutlet weak var senBtn: CornerButtons!
    @IBOutlet weak var navigate: UINavigationBar!
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var emLab: UILabel!
    @IBOutlet weak var wtLab: UILabel!
    
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
   // @IBOutlet weak var emailLabel: UILabel!
    
    
    var watsapp = ""
     var email = ""
    var info = "info@tdlly.com"
    var web = ""
    var call = ""
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        HomeVC.statusBar()

//        DispatchQueue.main.async {
//            self.getData()
//        }
        
        
       // maBtn.alignText()
        // wtsBtn.alignText()
          configLocalization()
        
        
        self.msgTf.layer.cornerRadius = 10.0
        self.msgTf.clipsToBounds = true
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }

       

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ContactUsVC.imageTapped(gesture:)))
        let tpGesture = UITapGestureRecognizer(target: self, action: #selector(ContactUsVC.infoTapped(gesture:)))
       // let taGesture = UITapGestureRecognizer(target: self, action: #selector(ContactUsVC.webTapped(gesture:)))
        numLabel.addGestureRecognizer(tapGesture)
        //emailLabel.addGestureRecognizer(taGesture)
        infoLabel.addGestureRecognizer(tpGesture)
        
        self.numLabel.isUserInteractionEnabled = true
       //  self.emailLabel.isUserInteractionEnabled = true
          self.infoLabel.isUserInteractionEnabled = true
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getData()
        
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UILabel) != nil {
            if let url = URL(string: "tel://\(self.call)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    
    @objc func infoTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UILabel) != nil {
            let url = NSURL(string: "mailto:\(self.info)")
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    
//    @objc func webTapped(gesture: UIGestureRecognizer) {
//        if (gesture.view as? UILabel) != nil {
//            print("weeeeeeeb", web)
//            if let url = URL(string: "\(self.web)" ) {
//                print("weeeeeeeb", web)
//                if #available(iOS 10, *){
//                    UIApplication.shared.open(url, options: [:])
//                }else{
//                    UIApplication.shared.openURL(url)
//                }
//
//
//            }
//           }
//         }
    
    
    @IBAction func webBtn(_ sender: Any) {
        print("weeb == \(self.web)")
        if let url = URL(string: "\(self.web)") {
            UIApplication.shared.open(url, options: [:])
        }
      
//
//        if let url = URL(string: "\(self.web)" ) {
//                            print("weeeeeeeb", web)
//                           // if #available(iOS 10, *){
//            UIApplication.shared.open(url, options: [:])
////                            }else{
////                                UIApplication.shared.openURL(url)
////                            }
//
//                        }
//
        
        
        
    }
    
    
    
    @IBAction func bkBtn(_ sender: Any) {
    //    audioPlayer.play()
       performSegue(withIdentifier: "conntactUnwind", sender: self)
 
    }
    
    
    @IBAction func SendBtn(_ sender: Any) {
        audioPlayer.play()
        guard let name = namTF.text, !name.isEmpty,
            let email = emaiTF.text, !email.isEmpty,
            let phoneNum = phoneTF.text , !phoneNum.isEmpty,
            let message = msgTf.text, !message.isEmpty,
            let subj = subjecTF.text, !subj.isEmpty
            else{ return AlertPopUP(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "fldsEm"))}
        API.ContactUS(name: name, email: email, subject: subj, message: message, phone: phoneNum) { (error: Error?, success: Bool) in
            if success {
                self.AlertPopUP(title: General.stringForKey(key: "suc"), message: General.stringForKey(key: "snt"))
                self.namTF.text = ""
                self.emaiTF.text = ""
                self.phoneTF.text = ""
                self.msgTf.text = ""
                self.subjecTF.text = ""
            } else {
                self.AlertPopUP(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "plsCchkUrCon"))
            }
        }
    }
    
    @IBAction func emailBtn(_ sender: Any) {
        audioPlayer.play()
        let url = NSURL(string: "mailto:\(self.email)")
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    
    
    @IBAction func whatsAppBtn(_ sender: Any) {
        audioPlayer.play()
        let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(self.watsapp)")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL as URL)
            }
        }
        else {
            AlertPopUP(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "installwts"))
            // Whatsapp is not installed
        }
//        let urlWhats = "whatsapp://send?phone=\(self.watsapp)?text=hello"
//        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
//            if let whatsappURL = URL(string: urlString) {
//                if UIApplication.shared.canOpenURL(whatsappURL){
//                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
//                }
//                else {
//                    AlertPopUP(title: "Error!", message: "You have to install whatsapp")
//                }
//            }
//        }
        
    }
    
    
    
    func getData() {
        Alamofire.request(URLs.contactUs) .responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                  print(jsonData)
                self.watsapp = jsonData["whatsapp"].object as! String
                  print(self.watsapp)
                
                self.email = jsonData["email"].object as! String
                print(self.email)
                self.call = jsonData["phone"].string!
                 self.web = jsonData["website"].string!
                self.numLabel.text = self.call
                
            } else { 
                print("faild")
            }
        }
    }
    
    func AlertPopUP(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configLocalization() {
        self.navigate.topItem?.title = General.stringForKey(key: "contact us")
        self.namTF.placeholder = General.stringForKey(key: "userName")
        self.emaiTF.placeholder = General.stringForKey(key: "E-mail")
        self.phoneTF.placeholder = General.stringForKey(key: "phone")
        self.subjecTF.placeholder = General.stringForKey(key: "subject")
        self.msgLabel.text = General.stringForKey(key: "message")
       // wtsBtn.setTitle(General.stringForKey(key: "connect through whatsapp"), for: .normal)
       // maBtn.setTitle(General.stringForKey(key: "connect trough e-mail"), for: .normal)
        senBtn.setTitle(General.stringForKey(key: "send"), for: .normal)
        emLab.text = General.stringForKey(key: "connect trough e-mail")
        wtLab.text = General.stringForKey(key: "connect through whatsapp")
    }
    
    
    
}
extension UIButton {
    
    func alignText(spacing: CGFloat = 12.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
}



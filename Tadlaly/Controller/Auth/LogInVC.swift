//
//  ViewController.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/20/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import SVProgressHUD


class LogInVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: ImageInsideTextField!
    @IBOutlet weak var passwordTF: ImageInsideTextField!
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var forBtn: UIButton!
    @IBOutlet weak var loBtn: CornerButtons!
    @IBOutlet weak var coBtn: UIButton!
    @IBOutlet weak var skBtn: SkipBorderButton!
    
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    static let shared = LogInVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        HomeVC.statusBar()
        self.emailTF.whitePlaceHolder()
        self.passwordTF.whitePlaceHolder()
//       if General.CurrentLanguage() == "ar"
//        {
//            self.lab.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
//            emailTF.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
//            passwordTF.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
//
//        }
        
        configLocalization()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        emailTF.delegate = self
        passwordTF.delegate = self
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch { print("faild to load sound") }
        
 }

    
    @IBAction func unwindLogin(segue: UIStoryboardSegue) {}

    
    @IBAction func loginBtn (_ sender: Any) {
        
        audioPlayer.play()
        LogInVC.shared.hudStart()

          guard let email = emailTF.text, !email.isEmpty ,
            let password = passwordTF.text, !password.isEmpty
            else {
                SVProgressHUD.dismiss()
                return showAlert(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "fldsEm"))
                  }
       
        API.logIn(email: email, password: password) { (error:Error?, success: Bool?) in
            if success! {
                UserDefaults.standard.set(password, forKey: "user_password")
                   } else {
                SVProgressHUD.dismiss()
                self.showAlert(title: General.stringForKey(key: "coWeak"), message: General.stringForKey(key:"plsCchkUrCon"))
            }
        }
    }
    
    
    
    @IBAction func forgotBtn(_ sender: Any) {
        audioPlayer.play()
        performSegue(withIdentifier: "forgotSeque", sender: self)
        
          }
    
    
    @IBAction func RegisterBtn(_ sender: Any) {
        
        audioPlayer.play()
        if API.isConnectedToInternet() {
            performSegue(withIdentifier: "RegisterSeque", sender: self)
        } else {
         self.showAlert(title: General.stringForKey(key: "conWeak"), message: General.stringForKey(key:"plsCchkUrCon"))
        }
        
         }
    
    @IBAction func skipBtn(_ sender: Any) {
        audioPlayer.play()
        let Sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc =   Sb.instantiateViewController(withIdentifier: "main") as! SWRevealViewController
         //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true,completion: nil)
        
    }
    
    
    func hudStart() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setForegroundColor(UIColor.white)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.darkGray)        //HUD Color
        SVProgressHUD.setRingThickness(6.0)
        //SVProgressHUD.setBackgroundLayerColor(UIColor.green)    //Background Color
        SVProgressHUD.show()
    }

    
    
    func configLocalization() {
        self.emailTF.placeholder = General.stringForKey(key: "userName")
        self.passwordTF.placeholder = General.stringForKey(key: "Password")
        self.lab.text = General.stringForKey(key: "Login")
        self.forBtn.setTitle(General.stringForKey(key: "forget your password?"), for: .normal)
        self.loBtn.setTitle(General.stringForKey(key: "Login"), for: .normal)
        self.coBtn.setTitle(General.stringForKey(key: "Create a new account"), for: .normal)
        self.skBtn.setTitle(General.stringForKey(key: "skip"), for: .normal)
    }
    
    
    func showAlert(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:General.stringForKey(key: "ok") , style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    
    
    
    
    
}
extension LogInVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return (true)
    }
}



extension UITextField {
    func whitePlaceHolder() {
         self.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.cgColor ])
    }
   
}

//
//  ForgetPasswordVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation


class ForgetPasswordVC: UIViewController {

    
   
    @IBOutlet weak var userNameTF: ImageInsideTextField!
    @IBOutlet weak var emailTF: ImageInsideTextField!
    @IBOutlet weak var labl: UILabel!
    @IBOutlet weak var reBtn: CornerButtons!

    
    
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            configLoca()
        HomeVC.statusBar()

        self.userNameTF.delegate = self
        self.emailTF.delegate = self
       // userNameTF.whitePlaceHolder()
       // emailTF.whitePlaceHolder()
        
            do {
               audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
               } catch {
                  print("faild to load sound")
               }

        
    }
    
//    override func didMove(toParentViewController parent: UIViewController?) {
//        super.didMove(toParentViewController: parent)
//        if parent == nil{
//            print("Back Button pressed.")
//          audioPlayer.play()
//        }
//    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        
        performSegue(withIdentifier:"un", sender: self)
        
        
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
        audioPlayer.play()
        guard let userName = userNameTF.text, !userName.isEmpty,
            let email = emailTF.text, !email.isEmpty
            else { return AlertPopUp(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "fldsEm"))}
        
        API.resetPass(user_Name: userName, user_email: email) { (error: Error?, _ success: Bool) in
            if success {
                self.userNameTF.text = ""
                self.emailTF.text = ""
            } else {
                SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "plsCchkUrCon"))
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        }
    }
        
    
   fileprivate func AlertPopUp(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    func configLoca() {
        self.navigationItem.title = General.stringForKey(key: "rest Password")
        userNameTF.placeholder = General.stringForKey(key: "userName")
        emailTF.placeholder = General.stringForKey(key: "E-mail")
        labl.text = General.stringForKey(key: "recover your account.we will send you a link to change your password")
        reBtn.setTitle(General.stringForKey(key: "rest Password"), for: .normal)
        
    }
    
    
    
}
extension ForgetPasswordVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        
        return (true)
    }
    
}

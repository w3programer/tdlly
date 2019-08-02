//
//  ProfileVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/27/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import Kingfisher
import SVProgressHUD


class ProfileVC: UIViewController {

    
    @IBOutlet weak var prof: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    @IBOutlet weak var emailLab: UILabel!
    @IBOutlet weak var passLab: UILabel!
    @IBOutlet weak var cityLab: UILabel!
    
    
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    fileprivate var imgString = ""
 
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLoca()
        
        HomeVC.statusBar()

        
        nameTF.delegate = self
         emailTF.delegate = self
          cityTF.delegate = self
         passTF.delegate = self
        phoneTF.delegate = self
        

        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
    
        self.nameView.floatView()
        self.phoneView.floatView()
        self.emailView.floatView()
        self.passView.floatView()
        self.cityView.floatView()
        
        userData()
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
      //  audioPlayer.play()
        self.performSegue(withIdentifier: "profileUnwind", sender: self)
      
    }
    
    
    
    @IBAction func picBtn(_ sender: Any) {
        audioPlayer.play()
        getImage()
    }
    @IBAction func nameBtn(_ sender: Any) {
        audioPlayer.play()
        self.nameTF.isUserInteractionEnabled = true
    }
    @IBAction func phoneBtn(_ sender: Any) {
        audioPlayer.play()
        self.phoneTF.isUserInteractionEnabled = true
    }
    @IBAction func emailBtn(_ sender: Any) {
        audioPlayer.play()
        self.emailTF.isUserInteractionEnabled = true
    }
    @IBAction func passBtn(_ sender: Any) {
        audioPlayer.play()
        self.passTF.isUserInteractionEnabled = true
    }
    @IBAction func cityBtn(_ sender: Any) {
        audioPlayer.play()
        self.cityTF.isUserInteractionEnabled = true
        getLocation()
    }
    
    
       func configLoca () {
        nameTF.placeholder = General.stringForKey(key: "userName")
        phoneTF.placeholder = General.stringForKey(key: "phone")
        emailTF.placeholder = General.stringForKey(key: "E-mail")
        passTF.placeholder = General.stringForKey(key: "Password")
        cityTF.placeholder = General.stringForKey(key: "city")
        nameLab.text = General.stringForKey(key: "userName")
        phoneLab.text = General.stringForKey(key: "phone")
        emailLab.text = General.stringForKey(key: "E-mail")
        passLab.text = General.stringForKey(key: "Password")
        cityLab.text =  General.stringForKey(key: "city")
        self.navi.topItem?.title = General.stringForKey(key: "my account")
            }
    

    
         fileprivate func getImage() {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                 let pickAlert = UIAlertController(title: General.stringForKey(key: "adpic"), message: General.stringForKey(key: "plsSel") , preferredStyle: .alert)
                 pickAlert.addAction(UIAlertAction(title: General.stringForKey(key: "tk"), style: .default, handler: { (action) in
                    picker.sourceType = .camera
                    self.present(picker, animated: true, completion: nil)
                   }))
                 pickAlert.addAction(UIAlertAction(title: General.stringForKey(key: "lib"), style: .default, handler: { (action) in
                   picker.sourceType = .photoLibrary
                   self.present(picker , animated: true, completion: nil)
                 }))
                 pickAlert.addAction(UIAlertAction(title:General.stringForKey(key: "Cancel"), style: .cancel, handler: { (action) in
                   pickAlert .dismiss(animated: true, completion: nil)
                }))
                   self.present(pickAlert, animated: true, completion: nil)
        
                  picker.delegate = self
        
                }
    
    
          fileprivate var pickedImg: UIImage? {
               didSet {
                guard let image = pickedImg else {return}
                    imgString  = base64(from: image)!
                       print(base64(from: image)!)
                    API.updateProfile(userName: "", userPhone: "", email: "", image: imgString, fullName: "", lon: "", lat: "", city: "") { (error: Error?, success:Bool?) in
                        if success! {
                            //prof.image = image
                        } else {
                            
                           self.ShowErr()
                                }
                           }
                        }
                       }
    
    
             fileprivate func base64(from image: UIImage) -> String? {
                let imageData = image.pngData()
                       if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
                        return imageString
                         }
                      return nil
                       }
    
    
    
    
 fileprivate func  getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
   
    

    
   fileprivate func userData() {
        if helper.getUserData() == true {
            let da = helper.getData()
            let urlString = URLs.image+da["user_photo"]!
            let url = URL(string: urlString)
            prof.kf.indicatorType = .activity
            prof.kf.setImage(with: url)
            self.nameTF.text = (UserDefaults.standard.object(forKey: "user_name") as! String)
            self.emailTF.text = (UserDefaults.standard.object(forKey: "user_email") as! String)
            self.cityTF.text = (UserDefaults.standard.object(forKey: "user_city") as! String)
            self.passTF.text = (UserDefaults.standard.object(forKey: "user_password") as! String)
            self.phoneTF.text = (UserDefaults.standard.object(forKey: "user_phone") as! String)
             } else {
           }
        }
    
 
    
    fileprivate func ShowErr() {
        SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "plsCchkUrCon"))
        SVProgressHUD.setShouldTintImages(false)
        SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
        SVProgressHUD.dismiss(withDelay: 3.0)
    }
    
    

}

extension ProfileVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation
        
        self.longTuide = "\(userLocation.coordinate.longitude)"
        self.latitude = "\(userLocation.coordinate.latitude)"
        print(self.longTuide)
        locationManager.stopUpdatingLocation()
        
           }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
           }


}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       // self.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgEdited = info[.editedImage] as? UIImage {
            self.pickedImg = imgEdited
        } else if let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImg = orignalImg
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}


extension ProfileVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            guard let nam = nameTF.text, !nam.isEmpty else {return}
            API.updateProfile(userName: nam, userPhone: "", email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                if success! {
                  self.nameTF.isUserInteractionEnabled = false
                } else {
                    self.ShowErr()

                }
            })
           self.nameTF.isUserInteractionEnabled = false
        } else if textField.tag == 2 {
            guard let pho = phoneTF.text, !pho.isEmpty else {return}
            API.updateProfile(userName: "", userPhone: pho, email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                if success! {
                self.phoneTF.isUserInteractionEnabled = false
                } else {
                    self.ShowErr()

                }
            })
            self.phoneTF.isUserInteractionEnabled = false
        } else if textField.tag == 3 {
            guard let mail = emailTF.text, !mail.isEmpty else {return}
            API.updateProfile(userName: "", userPhone: "", email: mail, image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
                if success! {
                    self.emailTF.isUserInteractionEnabled = false
                } else {
                    self.ShowErr()

                }
            })
            self.emailTF.isUserInteractionEnabled = false
        } else if textField.tag == 5 {
            
             let oldPass = UserDefaults.standard.object(forKey: "user_password") as! String
            print("old pass \(oldPass)")
            
            guard let pass = passTF.text, !pass.isEmpty else {return}
            print("pass \(pass)")
            API.updatePass(user_old_pass: oldPass, user_new_pass: pass, completion: { (error: Error?, success: Bool?) in
                if success! {
                    self.passTF.text = pass
                    self.passTF.isUserInteractionEnabled = false
                } else {
                    self.ShowErr()

                }
            })
            self.passTF.isUserInteractionEnabled = false
        } else if textField.tag == 6 {
            guard let loca = cityTF.text, !loca.isEmpty else {return}
            API.updateProfile(userName: "", userPhone: "", email: "", image: "", fullName: "", lon: "", lat: "", city: loca, completion: { (error: Error?, success: Bool?) in
                if success! {
                    self.cityTF.isUserInteractionEnabled = false
                } else {
                    self.ShowErr()
                }
            })
            self.cityTF.isUserInteractionEnabled = false
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
                self.nameTF.resignFirstResponder()
                self.emailTF.resignFirstResponder()
                self.cityTF.resignFirstResponder()
                self.passTF.resignFirstResponder()
                self.phoneTF.resignFirstResponder()
        
//        if textField.tag == 1 {
//            self.nameTF.isUserInteractionEnabled = false
//            if let nam = nameTF.text, !nam.isEmpty {
//                API.updateProfile(userName: nam, userPhone: "", email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success:Bool?) in
//                    if success! {
//                       self.nameTF.isUserInteractionEnabled = false
//                    } else {
//                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
//                    }
//                })
//            } else {AlertPopUp(title: "Error1", message: "You must fill fields!")}
//        } else if textField.tag == 2 {
//            self.phoneTF.isUserInteractionEnabled = false
//            if let pho = phoneTF.text, !pho.isEmpty {
//                API.updateProfile(userName: "", userPhone: pho, email: "", image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success: Bool?) in
//                    if success! {
//                        self.phoneTF.isUserInteractionEnabled = false
//                    } else {
//                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
//                    }
//                })
//            }
//            else {AlertPopUp(title: "Error1", message: "You must fill fields!")}
//        } else if textField.tag == 3 {
//            self.emailTF.isUserInteractionEnabled = false
//            if let mail = emailTF.text, !mail.isEmpty {
//                API.updateProfile(userName: "", userPhone: "", email: mail, image: "", fullName: "", lon: "", lat: "", city: "", completion: { (error: Error?, success:Bool?) in
//                    if success! {
//                      self.emailTF.isUserInteractionEnabled = false
//                    } else {
//                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
//                    }
//                })
//            } else {AlertPopUp(title: "Error1", message: "You must fill fields!")}
//        } else if textField.tag == 5 {
//            if let pass = passTF.text, !pass.isEmpty {
//                self.passTF.isUserInteractionEnabled = false
//                API.updatePass(user_old_pass: pass, user_new_pass: pass, completion: { (error: Error?, success:Bool?) in
//                    if success! {
//                        self.passTF.text = pass
//                     self.passTF.isUserInteractionEnabled = false
//                    } else {
//                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
//                    }
//                })
//            } else {
//                AlertPopUp(title: "Error!", message: "You must fill field")}
//        } else if textField.tag == 6 {
//            self.cityTF.isUserInteractionEnabled = false
//            if let loca = cityTF.text, !loca.isEmpty {
//                API.updateProfile(userName: "", userPhone: "", email: "", image: "", fullName: "", lon: longTuide, lat: latitude, city: loca, completion: { (error: Error?, success:Bool?) in
//                    if success! {
//                      self.cityTF.isUserInteractionEnabled = false
//                    } else {
//                        self.AlertPopUp(title: "Network Error‼️", message: "please check your network connection and try again")
//                    }
//                })
//             } else { AlertPopUp(title: "Error!", message: "You mus fill field")}
//           }
//
        return true
    }
    
    
    
    
}
extension UIView {
    
    func floatView() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
    }
    
}







//
//  RegisterVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import CoreLocation
import SVProgressHUD
import Alamofire

class RegisterVC: UIViewController {
   
   
    @IBOutlet weak var pro: UIImageView!
    @IBOutlet weak var userNamTF: ImageInsideTextField!
    @IBOutlet weak var phoneTF: ImageInsideTextField!
    @IBOutlet weak var emailTf: ImageInsideTextField!
    @IBOutlet weak var locationTf: ImageInsideTextField!
    @IBOutlet weak var passwordTf: ImageInsideTextField!
    @IBOutlet weak var rePasswordTF: ImageInsideTextField!
    @IBOutlet weak var reBtn: UIButton!
    @IBOutlet weak var creBtn: CornerButtons!
    @IBOutlet weak var nav: UINavigationBar!

   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()

    
    
     fileprivate  var locationManager:CLLocationManager!
     fileprivate var longTuide = ""
     fileprivate var latitude = ""
     fileprivate var imgString = ""
     fileprivate var isSelect = false
    

    var recNav = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        HomeVC.statusBar()

        
//        userNamTF.attributedPlaceholder = NSAttributedString(string:"placeholder text", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
//        phoneTF.attributedPlaceholder = NSAttributedString(string:"placeholder text",
//        attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
//        emailTf.attributedPlaceholder = NSAttributedString(string:"placeholder text", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
//        locationTf.attributedPlaceholder = NSAttributedString(string:"placeholder text", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
//        passwordTf.attributedPlaceholder = NSAttributedString(string:"placeholder text", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
//        rePasswordTF.attributedPlaceholder = NSAttributedString(string:"placeholder text", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
//
//
        
        
  
        if recNav == "menu" {
            self.nav.alpha = 1.0
            self.nav.topItem?.title = General.stringForKey(key: "Create account")
        } else {
          self.nav.alpha = 1.0
            self.navigationItem.title = General.stringForKey(key: "Create account")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        confirmDelegates()
         configLocaization()
          configGpsPermission()

       
        
        

   }

    
    @IBAction func unwindReg(segue: UIStoryboardSegue) {}

    
    @IBAction func unwindBtn(_ sender: Any) {
        if recNav == "menu" {
            performSegue(withIdentifier: "regUnwind", sender: self)
        } else {
            performSegue(withIdentifier: "re", sender: self)
        }
    }
    
    @IBAction func CreateBtn(_ sender: Any) {

          audioPlayer.play()
          LogInVC.shared.hudStart()
     guard  let Name = userNamTF.text?.trimmed, !Name.isEmpty ,
            let phoneNum = phoneTF.text?.trimmed, !phoneNum.isEmpty,
            let email = emailTf.text?.trimmed, !email.isEmpty,
            let password = passwordTf.text , !password.isEmpty ,
            let passwordAgain = rePasswordTF.text , !passwordAgain.isEmpty,
            let location = locationTf.text, !location.isEmpty
            else {
                SVProgressHUD.dismiss()
                return AlertPopUp(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "fldsEm"))
            }
        guard password == passwordAgain else {
            SVProgressHUD.dismiss()
            return AlertPopUp(title:General.stringForKey(key: "err"), message: General.stringForKey(key: "samePass"))
        }
       if isSelect == true {
            print("Go ahead")
        API.register(firstName: Name, lastName: Name, phoneNum: phoneNum, email: email, fullName: Name, password: password, location: location, latitude: latitude, longtuide: longTuide, userTokenId: "", image: imgString, completion: { (error: Error?, success:Bool) in
            if success {
                
               UserDefaults.standard.set(password, forKey: "user_password")

            } else {
                SVProgressHUD.dismiss()
                self.AlertPopUp(title: General.stringForKey(key: "conWeak"), message: General.stringForKey(key: "plschkUrCon"))
                  }
                })
            } else  {
             SVProgressHUD.dismiss()
            AlertPopUp(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "mSelect"))
                }
               }

    
    
    
    @IBAction func pickImgBtn(_ sender: Any) {

        audioPlayer.play()
         getImage()

    }


    
    @IBAction func chekBtn(_ sender: UIButton) {

            audioPlayer.play()
        if let image = UIImage(named: "che2") {
            sender.setImage(image,  for: .normal)
        }
        sender.isUserInteractionEnabled = false
           self.isSelect = true
    }


    @IBAction func rulesBtn(_ sender: Any) {
        performSegue(withIdentifier: "RulesSegue", sender: self)
    }
    
    

    func getImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true

        let pickAlert = UIAlertController(title: General.stringForKey(key: "adpic"), message:General.stringForKey(key: "plsSel") , preferredStyle: .alert)
        pickAlert.addAction(UIAlertAction(title: General.stringForKey(key: "tk"), style: .default, handler: { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        pickAlert.addAction(UIAlertAction(title: General.stringForKey(key: "lib"), style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker , animated: true, completion: nil)
        }))
        pickAlert.addAction(UIAlertAction(title: General.stringForKey(key: "Cancel"), style: .cancel, handler: { (action) in
            pickAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(pickAlert, animated: true, completion: nil)

        picker.delegate = self

    }


    var pickedImg: UIImage? {
        didSet {
            guard let image = pickedImg else {return}
            pro.image = image
            imgString  = base64(from: image)!
           // print(base64(from: image)!)
        }
    }


    func base64(from image: UIImage) -> String? {
        let imageData = image.pngData()
        if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
            return imageString
        }
        return nil
    }



    func AlertPopUp(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func configLocaization() {
        userNamTF.placeholder = General.stringForKey(key: "userName")
        phoneTF.placeholder = General.stringForKey(key: "nnn")
        emailTf.placeholder = General.stringForKey(key: "E-mail")
        locationTf.placeholder = General.stringForKey(key: "city")
        passwordTf.placeholder = General.stringForKey(key: "Password")
        rePasswordTF.placeholder = General.stringForKey(key: "re-password")
        creBtn.setTitle(General.stringForKey(key: "Create account"), for: .normal)
        reBtn.setTitle(General.stringForKey(key: "approve the terms and conditions"), for: .normal)
        
    }
    
    func configGpsPermission() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    
  fileprivate func confirmDelegates() {
        
        self.userNamTF.delegate = self
        self.phoneTF.delegate = self
        self.emailTf.delegate = self
        self.passwordTf.delegate = self
        self.rePasswordTF.delegate = self
        self.locationTf.delegate = self
        
    }
    
    
    
    
}
extension RegisterVC: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.userNamTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.emailTf.resignFirstResponder()
        self.passwordTf.resignFirstResponder()
        self.rePasswordTF.resignFirstResponder()
        self.locationTf.resignFirstResponder()

        return (true)
    }
}


extension RegisterVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if API.isConnectedToInternet() {
            let userLocation :CLLocation = locations[0] as CLLocation
            
            self.longTuide = "\(userLocation.coordinate.longitude)"
            self.latitude = "\(userLocation.coordinate.latitude)"
            print(self.longTuide)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    //print(placemark.locality!)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)
                    self.locationTf.text =  placemark.administrativeArea!
                 }
               }
             } else {
           }
        locationManager.stopUpdatingLocation()
              }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }


}




extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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


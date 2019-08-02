//
//  UpdateMyAdVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import Alamofire
import SwiftyJSON
//import ImagePicker
import Lightbox
import Kingfisher
import SVProgressHUD

class UpdateMyAdVC: UIViewController {
    
    
    
    
    @IBOutlet weak var departmentTF: UITextField!
    @IBOutlet weak var brancheTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phCheck: UIButton!
    @IBOutlet weak var priCheck: UIButton!
    @IBOutlet weak var conByAppLab: UILabel!
    @IBOutlet weak var unDeLab: UILabel!
    @IBOutlet weak var adCon: UILabel!
    @IBOutlet weak var adPic: UILabel!
    @IBOutlet weak var mxLab: UILabel!
    @IBOutlet weak var sndBtn: CornerButtons!
    @IBOutlet weak var nav: UINavigationBar!
    
    
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    
    var imgString = [String]()
    var array:[UIImage]=[]
    
    var sectionTitle = ""
    var branchTitle = ""
    var typeTitle = ""
    
    var showNum = "\(1)"
    
    let main = [CategoriesDep]()
    let typeData = ["جديد", "مستعمل","خدمة"]
    
    var recCity = ""
     var recTitle = ""
      var recContent = ""
       var recPrice = ""
      var recDate = ""
     var recNum = ""
    var recImgs = [UIImage]()
     var recId = ""
      var recStrings: [String] = []
       var recData = [MyAds]()
        var inx = [Int]()
    
    var categoryData = [CategoriesDep]()
     var branchData = [subData]()
      var departmentName = ""
       var branchName = ""
        var typeName = ""

    var recNewNum = ""
    
    
    var newImgs = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  print("recId\(recId)")
     //   print("recImgs",recStrings.count)
        
        HomeVC.statusBar()

        content.layer.cornerRadius = 10.0
        content.clipsToBounds = true
        
        downloadImgs()
         sub()
          checkBtns()
           displayData()
          localization()
         displayPickers()
        generatePermission()
        print("recTitle \(recTitle)")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
// recImgs = Array.init(repeating: #imageLiteral(resourceName: "logo"), count: 6)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bk), name: NSNotification.Name(rawValue: "bk"), object: nil)

        
        
    }
    
    @ objc func bk(notif: NSNotification) {
        self.array.removeAll()
        self.newImgs.removeAll()
        self.performSegue(withIdentifier:"myAdsUnwind", sender: self)
        
    }
    
    
    
    @IBAction func baaackBtn(_ sender: Any) {
        performSegue(withIdentifier: "myAdsUnwind", sender: self)
    }
    
    
    
    @IBAction func phoneCheckBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           //self.showNum = "show"
            self.showNum = "\(2)"
            self.audioPlayer.play()
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.showNum = "\(1)"
                 //self.showNum = "show"
                self.audioPlayer.play()
            }, completion: nil)
        }
    }
    
    @IBAction func priceCheckBtn(_ sender: UIButton) {
        self.audioPlayer.play()

        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.priceTF.text = ""
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.priceTF.text = "undefined"
            }, completion: nil)
        }
    }
    
    
    @IBAction func getImgBtn(_ sender: Any) {
        
        audioPlayer.play()
        getImage()
//        let config = Configuration()
//        config.doneButtonTitle = General.stringForKey(key: "finish")
//
//        config.noImagesTitle = General.stringForKey(key: "lib")
//        config.recordLocation = false
//        config.allowVideoSelection = true
//
//        let imagePicker = ImagePickerController(configuration: config)
//        imagePicker.imageLimit = 6
//        imagePicker.delegate = self
//
//
//        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        audioPlayer.play()
        LogInVC.shared.hudStart()
    guard let tit = titleTF.text, !tit.isEmpty,
           let loc = cityTF.text, !loc.isEmpty,
            let ph = phoneTF.text, !ph.isEmpty,
             let pri = priceTF.text, !pri.isEmpty,
              let con = content.text, !con.isEmpty,
               let d = departmentTF.text, !d.isEmpty,
                let s = brancheTF.text, !s.isEmpty,
                 let t = typeTF.text, !t.isEmpty

        else {
            SVProgressHUD.dismiss()
           return self.AlertPopUP(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "fldsEm"))
        }
        
//        print("recId\(recId)")
//        print("tit\(tit)")
//        print("loc\(loc)")
//        print("ph\(ph)")
//        print("pri\(pri)")
//        print("con\(con)")
//        print("departmentName\(departmentName)")
//        print("branchName\(branchName)")
//        print("typeName\(typeName)")
//        print("array\(array.count)")
        
//        for image in array {
//            let result = base64(from: image)
//            imgString.append(result!)
//        }
        
        API.updateMyAd(adId:recId ,main: departmentName, sub: branchName, title: tit, content: con, price: pri, type: typeName, lat: latitude, lon: longTuide, city: loc, phone: ph, showPH: showNum, imgs: newImgs) { (error: Error?, success: Bool?) in
            if success! {
                print("sucess")
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func sub() {
        print("looooooad sub")
        API.categoryDep { (error: Error?, data: [CategoriesDep]?) in
            if data != nil {
                self.categoryData = data!
            } else {
                print("no data")
            }
        }
    }
    
    func branches(id:String) {
        //
        Alamofire.request(URLs.categoryDep)
            .responseJSON { response in
                switch response.result
                {
            case .failure( _): break
                    
            case .success(let value):
              self.branchData.removeAll()
              let json = JSON(value)
                print(json)
                print("callllll")
                print("daaaaaa \(id)")
              if let dataArr = json.array{
                for dataArr in dataArr {
                  let mainId=dataArr["main_department_id"].string
                    print("main \(String(describing: mainId))")
                if  id == mainId  {
                        print("ss id \(id)")
                  if let dataArr = dataArr["sub_depart"].array {
                        print("inside")
                    for dataArr in dataArr {
                      let id = dataArr ["sub_department_id"].string
                      let name = dataArr ["sub_department_name"].string
                      let icon = dataArr ["sub_department_image"].string
                        print("it is \(id!)")
        self.branchData.append(subData(subName: name!, subImage: icon!, subId: id!))
                                        
                          }
                        }
                     }}
                    }
                 }
               }
             }
    
    
    
    func base64(from image: UIImage) -> String? {
        let imageData = image.pngData()
        if let imageString = imageData?.base64EncodedString(options: .lineLength64Characters) {
            return imageString
        }
        return nil
    }
    
    
    
    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func displayPickers() {
        
        let pickerView = UIPickerView()
        pickerView.tag=0
        pickerView.delegate = self
        departmentTF.inputView = pickerView
        
        let pickerViewBranch = UIPickerView()
        pickerViewBranch.tag=1
        pickerViewBranch.delegate = self
        brancheTF.inputView = pickerViewBranch
        
        let pickerViewType = UIPickerView()
        pickerViewType.tag=2
        pickerViewType.delegate = self
        typeTF.inputView = pickerViewType
        
    }
    
    func localization() {
        nav.topItem?.title = General.stringForKey(key: "updateMyAd")
        unDeLab.text = General.stringForKey(key: "Undefiend")
        titleTF.placeholder = General.stringForKey(key: "ad title")
        cityTF.placeholder = General.stringForKey(key: "city")
        phoneTF.placeholder = General.stringForKey(key: "phone")
        priceTF.placeholder = General.stringForKey(key: "price")
        adCon.text = General.stringForKey(key: "content")
        adPic.text = General.stringForKey(key: "add photo")
        mxLab.text = General.stringForKey(key: "max 6 images.scroll to load more photos")
        sndBtn.setTitle(General.stringForKey(key: "next"), for: .normal)
    }
    
    
    func displayData() {
        self.titleTF.text = recTitle
        self.cityTF.text = recCity
        self.content.text = recContent
        self.priceTF.text = recPrice
        self.phoneTF.text = recNum
        self.content.text = recContent
    }

    func generatePermission() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func checkBtns() {
        self.phCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.phCheck.setImage(UIImage(named:"che2"), for: .selected)
        self.priCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.priCheck.setImage(UIImage(named:"che2"), for: .selected)
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
            //  pro.image = image
            self.array.append(image)
            self.newImgs.append(image)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }

            // print(base64(from: image)!)
        }
    }
    
        func downloadImgs() {
            for str in self.imgString {
              let url = URL(string: str )
                KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                     //   self.array.removeAll()
                        self.array.append(value.image)
                      //  print("success")
                       // print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error): //break
                        print("Error: \(error)")
                    }
                }
            }
        }

    

}
extension UpdateMyAdVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
                self.cityTF.text = placemark.administrativeArea!
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
extension UpdateMyAdVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if (pickerView.tag == 0) {
            return categoryData.count
        }else if (pickerView.tag == 1){
            return branchData.count
        } else if (pickerView.tag == 2){
            return typeData.count
        }
        return 1
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
        if pickerView.tag == 0 {
            return categoryData[row].depName
        }else if pickerView.tag == 1{
            return branchData[row].subName
        } else if pickerView.tag == 2 {
            return typeData[row]
        }
        
        return " "
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            print(categoryData[row].depId)
            brancheTF.alpha=1
            branches(id: categoryData[row].depId)
            print("nnnnnn \(categoryData[row].depId)")
            departmentName=categoryData[row].depId
            departmentTF.text=categoryData[row].depName
        }else if pickerView.tag == 1 {
            branchName=branchData[row].subId
            brancheTF.text=branchData[row].subName
        } else if pickerView.tag == 2 {
            typeTF.text=typeData[row]
            if typeData[row] == "جديد" {
                typeName="1"
            } else if typeData[row] == "مستعمل" {
                typeName="2"
            } else {
                typeName="3"
                
            }
        }
        
        
    }
    
    
    
    
}

extension UpdateMyAdVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTF.resignFirstResponder()
        self.cityTF.resignFirstResponder()
        self.content.resignFirstResponder()
        self.priceTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        
        return true
       }
}
extension UpdateMyAdVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpdateCell", for: indexPath) as! UpdateMyAdCell
        
       
          //  cell.img.kf.indicatorType = .activity
            cell.img.image = array[indexPath.row]

        cell.remo.layer.setValue(indexPath.row, forKey: "indx")
        cell.remo.addTarget(self, action: #selector(deletUser(sender:)), for: UIControl.Event.touchUpInside)
        return cell
      }
    @objc func deletUser(sender:UIButton) {

        let i : Int = (sender.layer.value(forKey: "indx")) as! Int
        array.remove(at: i)
        collectionView.reloadData()

        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth-30)/3
        
        return CGSize.init(width: width, height: width)
    }

}




//extension UpdateMyAdVC:ImagePickerDelegate {
//    // MARK: - ImagePickerDelegate
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        guard images.count > 0 else { return }
//
//        let lightboxImages = images.map {
//            return LightboxImage(image: $0)
//        }
//
//        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
//        imagePicker.present(lightbox, animated: true, completion: nil)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//
//        array.append(contentsOf: images)
//        collectionView.reloadData()
//
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
//
//
//}
extension UpdateMyAdVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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



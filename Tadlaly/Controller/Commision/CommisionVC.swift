//
//  CommisionVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/29/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD


class CommisionVC: UIViewController {

    
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var adIdTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var seBtn: UIButton!
    @IBOutlet weak var ChooseBankLabel: UILabel!
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var bankLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var picLab: UILabel!
    
    @IBOutlet weak var vis: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    var bankArray = [BankAccounts]()
    var stringImg = ""
    var bank = ""
    var date = ""
    
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ChooseBankLabel.layer.cornerRadius = 8.0
        self.ChooseBankLabel.clipsToBounds = true
        
            self.tableView.delegate = self
            self.tableView.dataSource  = self
       configLoca()
        if API.isConnectedToInternet() {
            accountdata()
        } else {
            
        }
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        dateTF.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CommisionVC.displayDatePicker(sender:)), for: .valueChanged)
        dateTF.inputView = datePickerView
        self.date = dateTF.text!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        
        self.ChooseBankLabel.isUserInteractionEnabled = true
        vis.alpha = 0
        tableView.alpha = 0
        
    //self.bankTF.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommisionVC.imageTapped(gesture:)))
        ChooseBankLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UILabel) != nil {
            print("Bank Tapped")
            self.vis.alpha = 1.0
            self.tableView.alpha = 1.0
            self.tableView.transform = CGAffineTransform(scaleX: 0.3, y: 1)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options:.curveEaseOut, animations: {
                self.tableView.transform = .identity
            }, completion: nil)
        }
    }

    
    @IBAction func bkButton ( _ sender: Any ) {
    performSegue(withIdentifier: "commisionUnwind", sender: self)

    }
    
    @objc func displayDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateTF.text = dateFormatter.string(from: sender.date)
         date  = dateFormatter.string(from: sender.date)
        print(date)
 
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
            @IBAction func getPicBtn(_ sender: Any) {
              audioPlayer.play()
              getImage()
              }
    
    
          @IBAction func sendBtn(_ sender: Any) {
        
            audioPlayer.play()
            LogInVC.shared.hudStart()
            guard let userName = NameTF.text, !userName.isEmpty ,
                let amount = amountTF.text, !amount.isEmpty,
                let adCode = adIdTF.text, !adCode.isEmpty ,
                let transferFrom = phoneTF.text, !transferFrom.isEmpty,
                let bnk = ChooseBankLabel.text, !bnk.isEmpty
                else {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "fldsEm"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 3.0)
                    return
                        }
            print(userName,amount,bank,date,transferFrom,adCode,stringImg)

            API.transferPayment(userName: userName, amount: amount, bank: bank, date: date, person: transferFrom, code: adCode, image: stringImg) { (error: Error?, success: Bool) in
                if success {
                      } else {
                    SVProgressHUD.dismiss()
                    self.AlertPopUP(title: General.stringForKey(key: "conWeak"), message: General.stringForKey(key: "plschkUrCon"))
                  }
               }
            }
    
    
    
    
    func accountdata(){
        API.BankAccountsApi{(error :Error?, data: [BankAccounts]?) in
            if data != nil {
            self.bankArray = data!
            self.tableView.reloadWithAnimation()
            } else {
                print("no data")
                
            }
         }
      
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
            picker.dismiss(animated: true, completion: nil)
        }))
        self.present(pickAlert, animated: true, completion: nil)
        
        picker.delegate = self
        
    }
    
    
        var pickImg: UIImage? {
               didSet {
                   guard let image = pickImg else {return}
                   pic.image = image
                   stringImg = base64(from: image)!
                   print(base64(from: image)!)
                     }
                  }
    
    
        func base64(from image: UIImage) -> String? {
            let imageData = image.pngData()
              if let imageString = imageData?.base64EncodedString(options: .endLineWithLineFeed) {
            return imageString
                }
                return nil
             }
    
    

    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
         }
    
    
    func configLoca() {
        self.navi.topItem?.title = General.stringForKey(key: "pay commission")
         ChooseBankLabel.text = General.stringForKey(key: "Bank")
          NameTF.placeholder = General.stringForKey(key: "userName")
           amountTF.placeholder = General.stringForKey(key: "amount")
          phoneTF.placeholder = General.stringForKey(key: "phone")
         adIdTF.placeholder = General.stringForKey(key: "adId")
        seBtn.setTitle(General.stringForKey(key: "send"), for: .normal)
         bankLab.text = General.stringForKey(key: "theBankYouWantTransferAt")
          dateLab.text = General.stringForKey(key: "transferDate")
         picLab.text = General.stringForKey(key: "attachAcopyOfTheMoneyTransfer")
        dateTF.placeholder = General.stringForKey(key: "date")
        
    }
    
    
    
    
    
}
extension CommisionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bank", for: indexPath) as! BankCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.pics = bankArray[indexPath.item]
        cell.accName.text = bankArray[indexPath.row].account_name
        cell.bankName.text = bankArray[indexPath.row].account_bank_name
        cell.num.text = bankArray[indexPath.row].account_number
        cell.accNumLab.text = General.stringForKey(key: "accNo")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let animation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vis.alpha = 0
        tableView.alpha = 0
        ChooseBankLabel.text = bankArray[indexPath.row].account_bank_name
                  bank = bankArray[indexPath.row].account_bank_name
        
    }
    
    
    
    
}

//extension CommisionVC: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//           return bankArray.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//             let nameAcc = bankArray[row].account_bank_name
//        return nameAcc
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//          bankTF.text = bankArray[row].account_bank_name
//          bank = bankArray[row].account_bank_name
//
//             }
//
//
//
//
//}
extension CommisionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgEdited = info[.editedImage] as? UIImage {
            self.pickImg = imgEdited
        } else if let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickImg = orignalImg
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


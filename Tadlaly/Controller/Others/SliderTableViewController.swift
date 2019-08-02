//
//  SliderTableViewController.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 1/16/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class SliderTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImg: CircleImage!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var lngBtn: CornerButtons!
    @IBOutlet weak var addAdLab: UILabel!
    @IBOutlet weak var loginLab: UILabel!
    @IBOutlet weak var regsLab: UILabel!
    @IBOutlet weak var proLab: UILabel!
    
    @IBOutlet weak var myAdsLab: UILabel!
    @IBOutlet weak var msgsLab: UILabel!
    @IBOutlet weak var payLab: UILabel!
    @IBOutlet weak var contctLab: UILabel!
    @IBOutlet weak var aboutLab: UILabel!
    @IBOutlet weak var termsLab: UILabel!
    @IBOutlet weak var myFollowLab: UILabel!
    @IBOutlet weak var banklAB: UILabel!
    
    
    @IBOutlet weak var logOutBtn: CornerButtons!
    
    
    
    @IBOutlet weak var countLab: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
          userData()
        lngBtn.setTitle(General.stringForKey(key: "arabic"), for: .normal)
         addAdLab.text = General.stringForKey(key: "add ad")
          loginLab.text = General.stringForKey(key: "Login")
           regsLab.text = General.stringForKey(key: "Create a new account")
           proLab.text = General.stringForKey(key: "my account")
            myAdsLab.text = General.stringForKey(key: "my ads")
             msgsLab.text = General.stringForKey(key: "myFollow")
           payLab.text = General.stringForKey(key: "messages")
          contctLab.text = General.stringForKey(key: "pay commission")
         aboutLab.text = General.stringForKey(key: "contact us")
        termsLab.text = General.stringForKey(key: "terms and condtions")
       myFollowLab.text = General.stringForKey(key: "bankAcc")
        banklAB.text = General.stringForKey(key: "about")
         logOutBtn.setTitle(General.stringForKey(key: "logout"), for: .normal)
            
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    @IBAction func langBtn(_ sender: Any) {
        
        print("language Pressed")
        
        if General.CurrentLanguage() == "ar"
        {
            CheckLanguage.ChangeLanguage(NewLang: "en")
        }else
        {
            CheckLanguage.ChangeLanguage(NewLang: "ar")
        }
        helper.restartApp()
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        LogInVC.shared.hudStart()
        if helper.getUserData() == true {
            API.logOut { (error: Error?, success: Bool?) in
                if success! {
                  SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.dismiss()
                    self.AlertPopUP(title: General.stringForKey(key:"conWeak"), message: General.stringForKey(key:"plschkUrCon"))
                    
                    
                }
            }
        }
    }
    
    
    
    
    
    func userData() {
        if helper.getUserData() == true  {
        userNameLab.text = (UserDefaults.standard.object(forKey: "user_name") as! String)
            let da = helper.getData()
             let urlString = URLs.image+da["user_photo"]!
             let url = URL(string: urlString)
              profileImg.kf.indicatorType = .activity
                profileImg.kf.setImage(with: url)
   followCount(id: "1", userId: "\(helper.getApiToken())", type: "countfollow")
             self.countLab.alpha = 1

        } else {
            userNameLab.text = General.stringForKey(key: "visitor")
            self.profileImg.image = #imageLiteral(resourceName: "prof")
             self.countLab.alpha = 0
       }
    }
    
    
    func followCount(id:String,userId:String,type:String) {
        let url = URLs.followStatus
        let para: [String:Any] = [
            "department_id_fk":id,
            "user_id_fk":userId,
            "type":type
        ]
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case.failure(_): break
            case.success(let value):
                let js = JSON(value)
                print(js)
                if js["count_follow"].int! > 0 {
                     self.countLab.alpha = 1.0
                    self.countLab.text = "\((js["count_follow"].int)!)"
                } else {
                    self.countLab.alpha = 0
                }
            }
        }
    }
    
    func AlertPopUP(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return 14
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          var height: CGFloat
        
          if indexPath.row == 0 {
              height = 115
            } else {
              height = 44
            }
        
        if helper.getUserData() == true {
            if indexPath.row == 2 {
                height = 0
                }
            if indexPath.row == 3 {
                height = 0
            }
        } else {

            if indexPath.row == 4 { // profile
                height = 0
            }
            if indexPath.row == 5 { // myAds
                height = 0
            }
            if indexPath.row == 6 {
                height = 0
            }
           if indexPath.row == 7{ // msgs
                height = 0
            }
            if indexPath.row == 8 { // commision
                height = 0
            }
            if indexPath.row == 13 {
                height = 0
            }
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            performSegue(withIdentifier: "uploadSegue", sender: self)
        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "registerSegue", sender: self)
        }else if indexPath.row == 4 {
            performSegue(withIdentifier: "profileSegue", sender: self)
        }else if indexPath.row == 5 {
            if helper.getUserData() == true {
            performSegue(withIdentifier: "myAdsSegue", sender: self)
            } else {
                self.AlertPopUP(title: "Service not allowed", message: "please sgin up to access" )
            }
        } else if indexPath.row == 7 {
            if helper.getUserData() == true {
            performSegue(withIdentifier: "msgsSegue", sender: self)
            } else {
                self.AlertPopUP(title: "Service not allowed", message: "please sgin up to access" )
            }
        } else if indexPath.row == 8 {
            if helper.getUserData() == true {
            performSegue(withIdentifier: "commsionSegue", sender: self)
            } else {
                self.AlertPopUP(title: "Service not allowed", message: "please sgin up to access" )
            }
        } else if indexPath.row == 9 {
            performSegue(withIdentifier: "contactSegue", sender: self)
        } else if indexPath.row == 10 {
            performSegue(withIdentifier: "aboutSegue", sender: self)
        } else if indexPath.row == 11 {
            performSegue(withIdentifier: "bankSegue", sender: self)
        } else if indexPath.row == 13 {
            performSegue(withIdentifier: "termsSegue", sender: self)
        }else if indexPath.row == 6 {
            performSegue(withIdentifier: "foSegue", sender: self)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "termsSegue" {
            let lo =  segue.destination as? RulesVC
            lo?.recMenu = "menu"
        } else if segue.identifier == "registerSegue" {
            let d = segue.destination as? RegisterVC
            d?.recNav = "menu"
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
 

}

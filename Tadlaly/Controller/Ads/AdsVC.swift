//
//  AdsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/23/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import SVProgressHUD
import DZNEmptyDataSet
import Alamofire
import SwiftyJSON


class AdsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionConstant: NSLayoutConstraint!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var neBtn: CornerButtons!
    @IBOutlet weak var frBtn: CornerButtons!
    @IBOutlet weak var navi: UINavigationBar!
    
    @IBOutlet weak var follow: CornerButtons!
    
    fileprivate func AlertPopUp(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    fileprivate let hieght : CGFloat =  115.0
    
    fileprivate var locationManager:CLLocationManager!
     var longTuide = ""
     var latitude = ""
    
   // fileprivate var index = ""
    
    var nearAd = [Ad]()
    var sub = [Ad]()
   
    var branchData = [subData]()
    var didEndReached:Bool=false
    
    var textAr = ""
     var textEn = ""
    
    
    var selectedtitle = ""
     var selectedCity = ""
      var selectedDate = ""
       var selectedPrice = ""
      var selectedContent = ""
     var selectedPhone = ""
    var selectedShare = ""
     var selectedAdId = ""
      var selectedUserId = ""
       var selectedOwner = ""
      var selectedAdvId = ""
     var selectedShPhone = ""
    var selectedTyp = ""
     var selectedImages=[String]()
      var recSubTapped = ""
       var branchName=""
      var mainName=""
     var selView_count = ""
      var recDepId = ""
       var shareLink = ""
        var advertisement_user = ""
    
    
    var recDepa:String = ""
    var recIddx:Int = 0
    
    var pageNo:Int=1
     var pageFresh:Int = 1
      var pageSub:Int = 1
       var limit:Int=10
        var totalPages:Int=1
    
    var isNearLoad:Bool=false
     var isFreshLoad:Bool=false
      var isGetSubLoad:Bool=false
    
    
    var branchNamme = ""
    var currentPage:Int = 1
   
    var chckFollow:Bool = true
    
    
    
    
    var isDataLoading:Bool=false
    var pageN:Int=0
    var limt:Int=10
    var offset:Int=0 //pageNo*limit
    var didEndReched:Bool=false
    
    var totalItems = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeVC.statusBar()
         configLoca()
          GpsPermission()
           confirmProtocls()
            LogInVC.shared.hudStart()
             getTxt()
//        if recSubTapped == "selected" {
//            print("mainName \(mainName)")
//            branches(id:mainName)
//            print("BRANCH NAME \(branchName)")
//            getSubAds(no: pageSub, BranchName: branchName)
//
//          if helper.getUserData() == true {
//            followTypes(department_id_fk: recDepId, user_id_fk: "\(helper.getApiToken())", type: "checkfollow")
//          } else {
//            print("not A user")
//            }
//        }else{
//            getNearAds(no: pageNo)
//        }
        
        if recSubTapped == "selected" {
            self.collectionView.alpha = 1
             self.follow.isUserInteractionEnabled = true
            
        } else {
            self.collectionView.alpha = 0
            self.collectionConstant.constant = 0
            view.layoutIfNeeded()
            self.follow.isUserInteractionEnabled = false

        }
        
        self.upBtn.alpha = 0
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }

        
      
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if recSubTapped == "selected" {
            if recIddx == 1 {
                self.getMainCate(lati:latitude, long: longTuide, id: recDepa)
                branches(id: recDepa)
            } else if recIddx == 2 {
                print("mainName \(mainName)")
                branches(id:mainName)
                print("BRANCH NAME \(branchName)")
                getSubAds(no: pageSub, BranchName: branchName)
                // self.totalItems = nearAd[0].total_adv
                
                if helper.getUserData() == true {
                    followTyp(department_id_fk: recDepId, user_id_fk: "\(helper.getApiToken())", type: "checkfollow")
                } else {
                    print("not A user")
                }
                
            }
            
        }else{
            //  getNearAds(no: pageNo)
            getFreshAds(pageNo: pageFresh)
            
            
        }
        
        
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.flow), name: NSNotification.Name(rawValue: "flow"), object: nil)
        
   
        
    }
    
    
    @ objc func flow(notif: NSNotification) {
//        self.follow.setTitle(General.stringForKey(key: "unFollow"), for: .normal)
        
        self.followTyp(department_id_fk: branchName, user_id_fk: helper.getToken(), type: "checkfollow")
        
        SVProgressHUD.dismiss()
        
        
        print("reeeefreeeesh")
    }
    
//    @ objc func unflow(notif: NSNotification) {
//        self.follow.setTitle(General.stringForKey(key: "Follow"), for: .normal)
//        SVProgressHUD.dismiss()
//    }

    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        //getNearAds(no: pageNo)
//
//
//
//
//    }
//
    @IBAction func backBtn(_ sender: Any) {
          performSegue(withIdentifier: "adUnwind", sender: self)
        }
    
    
    
    @IBAction func followBtn(_ sender: Any) {
        if helper.getUserData() == false {
            self.AlertPopUp(title: "تنبيه", message: "لايمكنك متابعة القسم الا بعد التسجيل")
        }
        LogInVC.shared.hudStart()

             if helper.getUserData() == true {
//        followTyp(department_id_fk: recDepa,
//                    user_id_fk: "\(helper.getApiToken())",
//                     type: "checkfollow")
            if chckFollow == false {
                print("fooooooooooooollllllllow")
                API.followType(department_id_fk: recDepId, user_id_fk:"\(helper.getApiToken())" , type: "follow") { (error:Error?, success:Bool?) in
                    if success == true {
                        SVProgressHUD.dismiss()
                        //print("success followwww")

                    } else {
                        SVProgressHUD.dismiss()
                        //print("success not followwww")
                    }
                }
            } else if chckFollow == true {
                print("uuuuuuuuuunnnnnfooooooooooooollllllllow")
                followTyp(department_id_fk: recDepId, user_id_fk: "\(helper.getApiToken())", type: "unfollow")
                SVProgressHUD.dismiss()
            }
        } else {
           SVProgressHUD.dismiss()
          //  print("not a user")
        }
    }

    
    @IBAction func nearBtn(_ sender: Any) {
      
        audioPlayer.play()
        nearAd.removeAll()
        LogInVC.shared.hudStart()
        getNearAds(no: pageNo)
        
    }
    
 
    
    
    @IBAction func freshBtn(_ sender: Any) {
        audioPlayer.play()
         nearAd.removeAll()
        LogInVC.shared.hudStart()

          getFreshAds(pageNo: pageFresh)
        
    }
    
    
    @IBAction func upBtn(_ sender: Any) {
        
        audioPlayer.play()
        tableView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: 0.2) {
            self.upBtn.alpha = 0
        }
    }
    
    @IBAction func unwindToAds(segue: UIStoryboardSegue) {}
    
   
    
    func getNearAds(no:Int)  {
        
        isNearLoad=true
         isFreshLoad=false
          isGetSubLoad=false
        
        if helper.getUserData() == true {
            API.nearAds(pageNo: no, completion: { (error: Error?, data:[Ad]?) in
                print("near Ads calling with ")
                if data != nil {
                    self.nearAd.removeAll()
                    self.nearAd.append(contentsOf: data!)
                    print("mine",data!)
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                SVProgressHUD.dismiss(withDelay: 3.0)

            })
        } else {
            API.nonUserNearAds(pageNo: no, long: longTuide, lati: latitude
                , completion: {(error: Error?, data: [Ad]?) in
                    
                    print(" non near Ads calling with ")
                    if data != nil {
                        self.nearAd.removeAll()
                        self.nearAd.append(contentsOf: data!)
                        print("myData",data!)
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    SVProgressHUD.dismiss(withDelay: 3.0)

               })
             }
           }
    
    
        func getFreshAds(pageNo:Int) {
//            isNearLoad=false
//            isFreshLoad=true
//            isGetSubLoad=false
           // print("isFreshLoad\(isFreshLoad)")
           // print("fresh add func call")
            
             if helper.getUserData() == true {
                API.freshAds(pageNo: pageNo, completion: {(error: Error? , data: [Ad]?) in
                    //SVProgressHUD.show()
                    if data != nil {
                        self.nearAd.removeAll()
                        self.nearAd.append(contentsOf: data!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                       // self.tableView.reloadWithAnimation()
                        SVProgressHUD.dismiss()
                    }
                    SVProgressHUD.dismiss(withDelay: 3.0)
                })
            } else {
                API.nonUserFreshAds(pageNo: pageNo, long: longTuide, lati: latitude, completion: { (error:Error?, data: [Ad]?) in
                if data != nil {
                    self.nearAd.removeAll()
                    self.nearAd.append(contentsOf: data!)
                    self.tableView.reloadData()
                    //self.tableView.reloadWithAnimation()
                    SVProgressHUD.dismiss()
                   }
                    SVProgressHUD.dismiss(withDelay: 3.0)

                })
              }
            }
    
    
    

/// sub cate
    func getSubAds(no:Int,BranchName:String) {
        
//        isNearLoad=false
//        isFreshLoad=false
//        isGetSubLoad=true
        
        if helper.getUserData() == true {
            API.nearSubAds(pageNo: no, Sub: BranchName, completion: { (error: Error?,data:[Ad]?) in
                print("near sub ads")
                if data != nil {
                    self.nearAd.removeAll()
                    self.nearAd.append(contentsOf: data!)
                    self.tableView.reloadData()
                    print(data!)
                    SVProgressHUD.dismiss()
                }
                SVProgressHUD.dismiss(withDelay: 3.0)
            })
        } else {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
            API.nonUserSubAds(pageNo: no, subName: BranchName, long: longTuide, lati: latitude, completion: { (error: Error?,data:[Ad]?) in
                
                if data != nil{
                    self.nearAd.removeAll()
                 self.nearAd.append(contentsOf:data!)
                 self.tableView.reloadData()
                    print(data!)
                    SVProgressHUD.dismiss()
                }
                SVProgressHUD.dismiss(withDelay: 3.0)

            })
        }
    }
    


func branches(id:String) {
    Alamofire.request(URLs.categoryDep)
        .responseJSON { response in
            switch response.result
            {
            case .failure( _): break
            case .success(let value):
                let json = JSON(value)
//                print(json)
//                print("callllll")
//                print("daaaaaa \(id)")
                
                if let dataArr = json.array
                {
                    for dataArr in dataArr {
                        let mainId=dataArr["main_department_id"].string
                       // print("main \(mainId!)")
                        if  id == mainId  {
                           // print("ss id \(id)")
                            if let dataArr = dataArr["sub_depart"].array
                            {
                                //print("inside")
                                self.branchData.removeAll()
                                for dataArr in dataArr {
                                    let id = dataArr ["sub_department_id"].string
                                    let name = dataArr ["sub_department_name"].string
                                    let icon = dataArr ["sub_department_image"].string
                                 //   print("it is \(id!)")
                                 //   print("name \(name!)")

                                   // self.branchData.removeAll()
                                        
                                    let ss = subData(subName: name!, subImage: icon!, subId: id!)
                                   // self.branchData.removeAll()
                                    self.branchData.append(ss)
                                   
                                }
                                self.collectionView.reloadData()
                            }
                            
                        }
                    }}
                  }
                }
              }
  
  
    
    fileprivate func configLoca() {
        navi.topItem?.title = General.stringForKey(key: "ads")
         follow.setTitle(General.stringForKey(key: "follow"), for: .normal)
         neBtn.setTitle(General.stringForKey(key: "near ads"), for: .normal)
          frBtn.setTitle(General.stringForKey(key: "fresh ads"), for: .normal)
        if let bar  = tabBar.items {
            bar[0].title = General.stringForKey(key: "share")
            bar[1].title = General.stringForKey(key: "home")
            bar[2].title = General.stringForKey(key: "search")
        }
    }
    
    fileprivate func GpsPermission() {
        locationManager = CLLocationManager()
         locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func confirmProtocls() {
        tableView.delegate = self
         tableView.dataSource = self
          tableView.tableFooterView = UIView()
           tableView.emptyDataSetSource = self
            tableView.emptyDataSetDelegate = self
          collectionView.delegate = self
        collectionView.dataSource = self
       self.tabBar.delegate = self
        
    }
    
    
    
    
    
    func getTxt() {
        
        let url = URLs.sharedText
        Alamofire.request(url, method: .post).validate(statusCode: 200..<300).responseJSON { (response) in
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                let s = (jsonData["ar"].string)!
                self.textAr = s
                let d = (jsonData["en"].string)!
                self.textEn = d
//                print("finallllllllllly",self.textAr)
//                print("finnaaaaally",self.textEn)
//                print(s)
//                print(d)
            } else{
                print("faild")
            }
        }
    }
    
    
  fileprivate func openActivityController() {
    
    //print(self.textAr)
    // print(self.textEn)
        if helper.getUserData() == true {
            if General.CurrentLanguage() == "ar" {
               
                 let activityVC = UIActivityViewController(activityItems: [ textAr ,  URLs.appShare ], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        return
                    }
                   // self.shareApp(userId: helper.getApiToken())
                    //print("shhhare complete")
                }
            } else {
                let activityVC = UIActivityViewController(activityItems: [ textEn, URLs.appShare ], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        return
                    }
                //    self.shareApp(userId: helper.getApiToken())
                    
                  //  print("shhhare complete")
                }
            }
        } else {
            if General.CurrentLanguage() == "ar" {
                let activityVC = UIActivityViewController(activityItems: [ textAr ,  URLs.main], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        return
                    }
                  //  self.shareApp(userId: 0)
                    print("shhhare complete")
                }
            } else {
                let activityVC = UIActivityViewController(activityItems: [ textEn ,  URLs.main], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        print("share didnt taaaped")
                        // handle task not completed
                        return
                    }
                  //  self.shareApp(userId: 0)
                    
                    print("shhhare complete")
                }
            }
        }
    }
    
    
    
    func shareApp(userId:Int) {
        API.share(id: userId) { (error: Error?, success: Bool?) in
            if success! {
                print("success to share app")
            } else {
                print("error to share app")
            }
        }
    }
    
    
//    func getDayOfWeek(_ today:String) -> Int? {
//        let formatter  = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        guard let todayDate = formatter.date(from: today) else { return nil }
//        let myCalendar = Calendar(identifier: .gregorian)
//        let weekDay = myCalendar.component(.weekday, from: todayDate)
//        return weekDay
//    }
    
    
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        print("scrollViewDidEndDragging")
//        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
//        {
//            if !isDataLoading{
//                isDataLoading = true
//                self.pageN=self.pageN+1
//                self.limt=self.limt+10
//                self.offset=self.limt * self.pageN
//
//              //  loadCallLogData(offset: self.offset, limit: self.limit)
//              //  if indexPath.row == nearAd.count - 1 { //
//                 //   totalPages=nearAd[indexPath.row].totalPages
//                 //   if  pageNo < totalPages {
//                        if isNearLoad == false && isFreshLoad == false {
//                            // call getSub
//                            pageSub += 1
//                            print("near call")
//                            getSubAds(no: pageN, BranchName:branchNamme)
//                        }
//                        else if isNearLoad == false && isGetSubLoad == false {
//                            // call fresh
//                            pageFresh += 1
//                            print("fresh call")
//                            print("pageNo  \(pageFresh)")
//                            getFreshAds(pageNo: pageN)
//                        }
//                            // call near
//                        else{
//                            pageNo += 1
//                            print("get near call")
//                            getNearAds(no: pageN)
//                        }
//                    }
//                }
//           // }
//       // }
//    }

    
    
    
    
    fileprivate func getMainCate(lati:String, long:String, id:String) {
        if API.isConnectedToInternet() {
            API.getMainCate(lati: lati, long: long, id: id) { (err:Error?, data:[Ad]?) in
                if data != nil {
                    self.nearAd.removeAll()
                    self.nearAd.append(contentsOf: data!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    
    
    
    
   fileprivate  func sortFreshAds(this: Ad , that:Ad) -> Bool {
      //  let sortedImages = nearAd.sorted(by: { $0.date > $1.date})
        return this.date > that.date
    }
    
    fileprivate func sortNearAd(this: Ad, that: Ad) ->Bool {
        return this.distance < that.distance
    }
   
    
    
    
    
    
    
   fileprivate func followTyp(department_id_fk:String,
                                user_id_fk:String,
                                type:String) {
    
        let url = URLs.followStatus
        let para:[String:Any] = [
            "department_id_fk":department_id_fk,
            "user_id_fk":user_id_fk,
            "type":type
        ]
        
        Alamofire.request(url, method: .post , parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case.failure(let error):
                print(error)
            case.success(let value):
                let js = JSON(value)
                print("cheeeeeck",js)
                let status_follow = js["success_follow"].intValue
                //print(status_follow!)
                if status_follow == 1 {
                    self.chckFollow = true
                    self.follow.setTitle(General.stringForKey(key: "unFollow"), for: .normal)
                    
                    helper.followStaus(status: 0)
                   // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unflow"), object: nil)
                    SVProgressHUD.dismiss()
                } else {
                    self.chckFollow = false
                    //  helper.followStaus(status: 1)
                  //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "flow"), object: nil)
                    helper.followStaus(status: 1)
                    self.follow.setTitle(General.stringForKey(key: "follow"), for: .normal)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    
    
    
    
    
}
extension AdsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nearAd.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! AdCell

            cell.pics = nearAd[indexPath.item]
             cell.titleLab.text = nearAd[indexPath.row].adeTitle
              cell.cityLab.text = nearAd[indexPath.row].city
               cell.priceLab.text = nearAd[indexPath.row].adePrice
                cell.dateLab.text = nearAd[indexPath.row].date
                 cell.distanceLab.text = nearAd[indexPath.row].distance
        
//        if nearAd[indexPath.row].read_status == true {
//            cell.readLab.alpha = 1.0
//             cell.readLab.text = General.stringForKey(key: "read")
//              cell.readLab.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0, blue: 0.3058823529, alpha: 0.7425888271)
//
//        } else {
//            cell.readLab.alpha = 0
//        }
        
        
//        if nearAd[indexPath.row].typ == "2" {
//            cell.kindLabel.text = "مستعمل"
//             cell.kindLabel.backgroundColor = UIColor.darkGray
//              cell.kindLabel.textColor = UIColor.white
//
//        } else if nearAd[indexPath.row].typ == "1" {
//             cell.kindLabel.text = "جديد"
//              cell.kindLabel.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0, blue: 0.3058823529, alpha: 0.7425888271)
//                cell.kindLabel.textColor = UIColor.white
//        } else {
//            cell.kindLabel.text = "خدمة"
//             cell.kindLabel.backgroundColor = UIColor.darkGray
//              cell.kindLabel.textColor = UIColor.white
//        }
//        if indexPath.row == nearAd.count - 1 { // last cell
//            totalItems = nearAd[indexPath.row].total_adv
//            if totalItems > nearAd.count { // more items to fetch
//
//                if isNearLoad == false && isFreshLoad == false {
//                                                    // call getSub
//                           pageSub += 1
//                         print("near call")
//                    getSubAds(no: pageSub, BranchName:branchNamme)
//                        }
//            else if isNearLoad == false && isGetSubLoad == false {
//                                                    // call fresh
//                        pageFresh += 1
//                    print("fresh call")
//                  print("pageNo  \(pageFresh)")
//                getFreshAds(pageNo: pageNo)
//            }
//                                        // call near
//                     else{
//                        pageNo += 1
//                    print("get near call")
//            getNearAds(no: pageNo)
//               }
//            }
//        }
//        if tableView.isLast(for: indexPath) == true{
//                if indexPath.row == nearAd.count - 1 { //
//                  ///      totalPages=nearAd[indexPath.row].totalPages
//                    //    if  pageNo < totalPages {
//                            if isNearLoad == false && isFreshLoad == false {
//                                // call getSub
//                                 pageSub += 1
//                                print("near call")
//                                getSubAds(no: pageSub, BranchName:branchNamme)
//                            }
//                            else if isNearLoad == false && isGetSubLoad == false {
//                                // call fresh
//                                 pageFresh += 1
//                                print("fresh call")
//                                print("pageNo  \(pageFresh)")
//                                getFreshAds(pageNo: pageNo)
//                            }
//                            // call near
//                            else{
//                                 pageNo += 1
//                                  print("get near call")
//                                getNearAds(no: pageNo)
//                         //   }
//                        }
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return hieght
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   index = "\(indexPath.row)"
//if "\(helper.getApiToken())" == self.nearAd[indexPath.row].advertisement_user {
            
       // } else {
        selectedContent = self.nearAd[indexPath.row].content
         selectedCity = self.nearAd[indexPath.row].city
          selectedDate = self.nearAd[indexPath.row].date
           selectedtitle = self.nearAd[indexPath.row].adeTitle
            selectedPrice = self.nearAd[indexPath.row].adePrice
             selectedPhone = self.nearAd[indexPath.row].phone
            selectedUserId = self.nearAd[indexPath.row].userId
           selectedShare = self.nearAd[indexPath.row].viewShare
          selectedOwner = self.nearAd[indexPath.row].userName
         selectedAdId = self.nearAd[indexPath.row].adId
        selectedAdvId = self.nearAd[indexPath.row].adverId
         selectedShPhone = self.nearAd[indexPath.row].showPhone
          selectedTyp = self.nearAd[indexPath.row].typ
           selectedImages=self.nearAd[indexPath.row].phots
            selView_count = self.nearAd[indexPath.row].view_count
             shareLink = self.nearAd[indexPath.row].share_link
            advertisement_user = self.nearAd[indexPath.row].advertisement_user
        performSegue(withIdentifier: "ContentSegue", sender: self)
     //   }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "ContentSegue" {
            let adContentVc = segue.destination as? AdContentVC
            adContentVc?.recCity = selectedCity
             adContentVc?.recContent = selectedContent
              adContentVc?.recPrice = selectedPrice
               adContentVc?.recTitle = selectedtitle
                adContentVc?.recDate = selectedDate
               adContentVc?.recNum = selectedPhone
              adContentVc?.recShare = selectedShare
             adContentVc?.recAdId = selectedAdId
            adContentVc?.recOwner = selectedOwner
             adContentVc?.recIdAdv = selectedAdvId
              adContentVc?.recShoPh = selectedShPhone
               adContentVc?.recUserId = selectedUserId
                adContentVc?.recImgs=selectedImages
               adContentVc?.recTyp = selectedTyp
              adContentVc?.recPage = "adsPage"
            adContentVc?.recView_count = selView_count
             adContentVc?.recLink = shareLink
              adContentVc?.recAdvertisement_user = advertisement_user
            
                }
             }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let animation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
//
        
//        if indexPath.row == nearAd.count - 1 { //
//            totalPages=nearAd[indexPath.row].totalPages
//            if  pageNo < totalPages {
//                if isNearLoad == false && isFreshLoad == false {
//                    // call getSub
//                     pageSub += 1
//                    print("near call")
//                    getSubAds(no: pageSub, BranchName:branchNamme)
//                }
//                else if isNearLoad == false && isGetSubLoad == false {
//                    // call fresh
//                     pageFresh += 1
//                    print("fresh call")
//                    print("pageNo  \(pageFresh)")
//                    getFreshAds(pageNo: pageNo)
//                }
//                // call near
//                else{
//                     pageNo += 1
//                      print("get near call")
//                    getNearAds(no: pageNo)
//                }
//            }
//        }
    
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.upBtn.alpha = 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       // print("scrollViewDidEndDecelerating")
    }
 
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == 0) {
            self.upBtn.alpha = 0
        }
    }

}
    
extension AdsVC: CLLocationManagerDelegate {
    
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


extension AdsVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if (item.tag == 4) {
            print("1")
            audioPlayer.play()
                openActivityController()
        } else if (item.tag == 5){
            audioPlayer.play()
            if helper.getUserData() == false {
                performSegue(withIdentifier: "adUnwind", sender: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else if (item.tag == 6) {
            audioPlayer.play()
            performSegue(withIdentifier: "SearchSe", sender: self)
            
        }
    }
    

    
}
extension AdsVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return branchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! AdCollectionCell
        
        cell.subLabel.text = branchData[indexPath.row].subName
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth-30)/3
        
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         branchNamme=branchData[indexPath.row].subId
      //  print("branchreee Name  \(String(describing: branchNamme))")
        getSubAds(no: pageSub, BranchName: branchNamme)
    }
                   
    
}
extension AdsVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        var str = ""
//        if API.isConnectedToInternet() == false{
//             str = General.stringForKey(key: "conWeak")
//        } else if nearAd.isEmpty == true{
//            str = General.stringForKey(key: "لا توجد إعلانات ")
//        }
//        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {

        return UIImage(named: "empg.png")
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = General.stringForKey(key: "try")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }



}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut , animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
          }
        }


    func isLast(for indexPath: IndexPath) -> Bool {
        
        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1
        
        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
    
    
    
}

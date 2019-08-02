//
//  MyFollowersVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 4/2/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import DZNEmptyDataSet
import SVProgressHUD
import Alamofire
import SwiftyJSON




class MyFollowersVC: UIViewController {

    
    
    @IBOutlet weak var navigat: UINavigationBar!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var moveUpBtn: UIButton!
    
    
    var followData = [MyFollowers]()
    
    var currentPage:Int = 1
    var totalPages:Int = 1
    var recPag = ""
    
    
    
    
fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate let height : CGFloat = 115.0
      fileprivate var audioPlayer = AVAudioPlayer()
       fileprivate var locationManager:CLLocationManager!
        fileprivate var longTuide = ""
         fileprivate var latitude = ""
    
    
    var selecttitle = ""
     var selectCity = ""
      var selectDate = ""
       var selectPrice = ""
        var selectContent = ""
         var selectPhone = ""
         var selectShare = ""
        var selectAdId = ""
       var selectUserId = ""
      var selectOwner = ""
     var selectAdvId = ""
    var selectShoNum = ""
     var selectTyp = ""
      var selectImgs = [String]()
       var selView_count = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HomeVC.statusBar()
         self.moveUpBtn.alpha = 0
            setUpTableView()
              setLocation()
        
        
        if helper.getUserData() == true {
            getMyData(page:currentPage)
        } else {
            print("not a user")
        }
        
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }

    }
    

   
    @IBAction func bkBtn(_ sender: Any) {
       // audioPlayer.play()
        if recPag == "r" {
            performSegue(withIdentifier:"un", sender: self)

        } else {
            performSegue(withIdentifier:"myFollowUnwindb", sender: self)

        }
    }
    
    @IBAction func upBtn(_ sender: Any) {
        
        self.moveUpBtn.alpha = 0
        listTableView.setContentOffset(.zero, animated: true)
        
    }
    
    
    func setUpTableView() {
        listTableView.delegate = self
         listTableView.dataSource = self
        listTableView.emptyDataSetSource = self
       listTableView.emptyDataSetDelegate = self
    }
    
    func getMyData(page:Int) {
         pagination(nu: page)
        API.myFollowers(pageNu: page, lat: latitude, lon: longTuide) { (error:Error?, data:[MyFollowers]?) in
            if data != nil {
                self.followData.append(contentsOf: data!)
                 self.listTableView.reloadData()
            } else {
                print("data is nil")
            }
        }
    }
    
    
    
    func pagination(nu:Int) {
        let url = URLs.myFollow+"\(nu)"
        let para:[String:Any] = [
            "user_google_lat": latitude,
            "user_gogle_long":longTuide
            ]
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print("Pagination company",error)
            case .success(let value):
                let jsonData = JSON(value)
                let json = jsonData["meta"]
                print(json)
                let last = json["last_page"].int
                print(last!)
                self.totalPages = last!
            }
        }
    }
   
    
    func setLocation() {
        locationManager = CLLocationManager()
         locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.moveUpBtn.alpha = 1
    }
    
    @IBAction func unwindToFollow(segue: UIStoryboardSegue) {}

}
extension MyFollowersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! MyFollowCell
        
        cell.pics = followData[indexPath.item]
         cell.cityLab.text = followData[indexPath.row].city
          cell.distanceLab.text = followData[indexPath.row].distance
           cell.dateLab.text = followData[indexPath.row].date
            cell.titleLab.text = followData[indexPath.row].adeTitle
             cell.priceLab.text = followData[indexPath.row].adePrice
        
        if followData[indexPath.row].read_status == true {
            cell.selectionStyle = UITableViewCell.SelectionStyle.gray
        } else {
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        
        
//        if followData[indexPath.row].typ == "2" {
//            cell.kindLab.text = "used"
//             cell.kindLab.backgroundColor = UIColor.darkGray
//              cell.kindLab.textColor = UIColor.white
//
//        } else if followData[indexPath.row].typ == "1" {
//            cell.kindLab.text = "New"
//             cell.kindLab.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0, blue: 0.3058823529, alpha: 0.7425888271)
//              cell.kindLab.textColor = UIColor.white
//        } else {
//            cell.kindLab.text = "none"
//             cell.kindLab.backgroundColor = UIColor.darkGray
//              cell.kindLab.textColor = UIColor.white
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == followData.count - 1 { //
            if  currentPage < totalPages {
                currentPage += 1
                 getMyData(page:currentPage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectContent = self.followData[indexPath.row].content
         selectCity = self.followData[indexPath.row].city
          selectDate = self.followData[indexPath.row].date
           selecttitle = self.followData[indexPath.row].adeTitle
            selectPrice = self.followData[indexPath.row].adePrice
            selectPhone = self.followData[indexPath.row].phone
           selectUserId = self.followData[indexPath.row].userId
          selectShare = self.followData[indexPath.row].viewShare
         selectOwner = self.followData[indexPath.row].userName
        selectAdId = self.followData[indexPath.row].adId
         selectShoNum = self.followData[indexPath.row].showPhone
          selectTyp = self.followData[indexPath.row].typ
           selectImgs = followData[indexPath.row].phots
            selView_count = followData[indexPath.row].view_count
        performSegue(withIdentifier: "myfollowContent", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "myfollowContent" {
            let adContentVc = segue.destination as? AdContentVC
            adContentVc?.recContent = selectContent
             adContentVc?.recAdId = selectAdId
              adContentVc?.recShare = selectShare
               adContentVc?.recNum = selectPhone
               adContentVc?.recDate = selectDate
              adContentVc?.recPrice = selectPrice
             adContentVc?.recUserId = selectUserId
            adContentVc?.recCity = selectCity
             adContentVc?.recTitle = selecttitle
              adContentVc?.recOwner = selectOwner
               adContentVc?.recIdAdv = selectAdvId
               adContentVc?.recShoPh = selectShoNum
              adContentVc?.recTyp = selectTyp
             adContentVc?.recImgs = selectImgs
            adContentVc?.recView_count = selView_count
             adContentVc?.recPage = "followPage"
        }
    }
    
    
    
    
    
}
extension MyFollowersVC: CLLocationManagerDelegate {
    
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
extension MyFollowersVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = General.stringForKey(key: "nofo")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empg.png")
    }
    
}

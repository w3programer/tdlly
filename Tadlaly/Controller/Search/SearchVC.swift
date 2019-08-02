//
//  SearchVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/24/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import DZNEmptyDataSet
import SVProgressHUD
import SearchTextField

class SearchVC: UIViewController {

    
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upButn: UIButton!
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    
    fileprivate var receiveData = [Ad]()
    fileprivate var searchTx = ""
    
    
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
                   var selLink = ""
                    var usr = ""
    
    
    var inputs: [String] = []
    
    fileprivate let height : CGFloat = 115.0
    
    var filteredData: [String]!

    
    // pagination
    var pageNo:Int=1
    var limit:Int=10
    var totalPages:Int=1 //pageNo*limit
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configSerachTXT()
        HomeVC.statusBar()

        
        searchTxt.placeholder = General.stringForKey(key: "search")
        self.upButn.alpha = 0
        self.searchTxt.frame.size.width = 290.0
        self.searchTxt.autocorrectionType = .no
        self.searchTxt.spellCheckingType = .no
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.searchTxt.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        
         tableView.emptyDataSetDelegate = self
         tableView.emptyDataSetSource = self
    }
    
    
//    func configSerachTXT() {
//        searchTxt.filterStrings(inputs)
//        searchTxt.maxResultsListHeight = 200
//
//        searchTxt.theme.font = UIFont.systemFont(ofSize: 12)
//        searchTxt.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
//        searchTxt.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//        searchTxt.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
//        searchTxt.theme.cellHeight = 50
//
//        searchTxt.forceRightToLeft = true
//
//      //  searchTxt.text = inputs[(IndexPath as NSIndexPath).row].title
//
//       // searchTxt.inlineMode = true
//
//
//        searchTxt.itemSelectionHandler = { inputs , itemPosition in
//            let item = inputs[itemPosition].title
//            self.searchTxt.text = item
//        }
//
//
//    }

    
    @IBAction func bkBtn(_ sender: Any) {
     //   audioPlayer.play()
        performSegue(withIdentifier: "searchUnwind", sender: self)

    }
    
    @IBAction func moveUpBtn(_ sender: Any) {
        
        audioPlayer.play()
        self.upButn.alpha = 0
        tableView.setContentOffset(.zero, animated: true)
        
        
    }
    
    
    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {}
    
    func searchStart(txt: String, lo: String, la: String,page:Int) {
        if helper.getUserData() == true {
            API.searchByTitle(searchTitle: txt, long: lo, lati: la, userId: "\(helper.getApiToken())", pageNo: pageNo , completion: { (error: Error?, data: [Ad]?) in
                if (data != nil) {
                    self.receiveData.append(contentsOf: data!)
                    print(data!)
                self.tableView.reloadWithAnimation()
                } else {
                    SVProgressHUD.show(UIImage(named: "empg.png")!, status: General.stringForKey(key: "noData"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    print("no data found")
                }
            })
        } else {
            API.searchByTitle(searchTitle: txt, long: lo, lati: la, userId: "all", pageNo: pageNo, completion: { (error: Error?, data: [Ad]?) in
                if (data != nil) {
                self.receiveData = data!
                    print(data!)
                self.tableView.reloadWithAnimation()
                } else {
                    SVProgressHUD.show(UIImage(named: "empg.png")!, status: General.stringForKey(key: "noData"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                    print("no data found")

                }
            })
        }
    }
    
    
    

    
    
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receiveData.count
        
             }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! searchCell
        
        cell.pics = receiveData[indexPath.item]
    
        cell.titleCell.text = receiveData[indexPath.row].adeTitle
         cell.cityCell.text = receiveData[indexPath.row].city
          cell.dateCell.text = receiveData[indexPath.row].date
           cell.distanceCell.text = receiveData[indexPath.row].distance
            cell.priceCell.text = receiveData[indexPath.row].adePrice
 
//        if receiveData[indexPath.row].typ == "2" {
//            cell.kindCell.text = "مستعمل"
//             cell.kindCell.backgroundColor = UIColor.darkGray
//              cell.kindCell.textColor = UIColor.white
//
//        } else if receiveData[indexPath.row].typ == "1" {
//            cell.kindCell.text = "جديد"
//             cell.kindCell.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0, blue: 0.3058823529, alpha: 0.7425888271)
//              cell.kindCell.textColor = UIColor.white
//        } else {
//            cell.kindCell.text = "خدمة"
//             cell.kindCell.backgroundColor = UIColor.darkGray
//              cell.kindCell.textColor = UIColor.white
//        }
//
//        if receiveData[indexPath.row].read_status == true {
//            cell.readLabel.alpha = 1.0
//             cell.readLabel.text = General.stringForKey(key: "read")
//              cell.readLabel.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0, blue: 0.3058823529, alpha: 0.7425888271)
//
//        } else {
//            cell.readLabel.alpha = 0
//        }
//
        
        return cell
        
          }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if indexPath.row == receiveData.count - 1 { //
//            totalPages=receiveData[indexPath.row].totalPages
//            if  pageNo < totalPages {
//                pageNo += 1
//              //  loadData(pageNumber: pageNo)
//                    searchStart(txt: searchTx, lo: longTuide, la: latitude, page: pageNo)
//            }
//        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectContent = self.receiveData[indexPath.row].content
         selectCity = self.receiveData[indexPath.row].city
          selectDate = self.receiveData[indexPath.row].date
           selecttitle = self.receiveData[indexPath.row].adeTitle
          selectPrice = self.receiveData[indexPath.row].adePrice
         selectPhone = self.receiveData[indexPath.row].phone
        selectUserId = self.receiveData[indexPath.row].userId
         selectShare = self.receiveData[indexPath.row].viewShare
          selectOwner = self.receiveData[indexPath.row].userName
           selectAdId = self.receiveData[indexPath.row].adId
            selectShoNum = self.receiveData[indexPath.row].showPhone
           selectTyp = self.receiveData[indexPath.row].typ
          selectImgs = receiveData[indexPath.row].phots
         selView_count = receiveData[indexPath.row].view_count
           selLink = receiveData[indexPath.row].share_link
          self.usr = receiveData[indexPath.row].advertisement_user
        
        performSegue(withIdentifier: "SearchContent", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "SearchContent" {
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
            adContentVc?.recLink = selLink
             adContentVc?.recAdvertisement_user = usr
            adContentVc?.recPage = "searchPage"
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.upButn.alpha = 1
    }
    
    
    
    
    
    
}
extension SearchVC: CLLocationManagerDelegate {
    
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



extension SearchVC: UITextFieldDelegate {


    func textFieldDidEndEditing(_ textField: UITextField) {
        self.searchTxt.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        audioPlayer.play()
        self.searchTx = self.searchTxt.text!
       // print("good,\(searchTx)")
        self.inputs.append(self.searchTxt.text!)
        //helper.saveInputs(input: searchTx)
        self.searchTxt.resignFirstResponder()
        searchStart(txt: searchTx, lo: longTuide, la: latitude, page: pageNo)
        
        return true
    }
    
        
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("two",self.searchTxt.text!)
        //self.searchTxt.text! =  UserDefaults.standard.object(forKey: "inputsArray") as! String
      
        
        return true
    }

    
    
    
    
}


extension SearchVC: DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = General.stringForKey(key: "loo")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "sear.png")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = General.stringForKey(key: "exp")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
}





















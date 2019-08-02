//
//  MyAdsVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import DZNEmptyDataSet


class MyAdsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var msgView: UIVisualEffectView!
    @IBOutlet weak var deletLab: UILabel!
    @IBOutlet weak var soldCheck: UIButton!
    @IBOutlet weak var dontCheck: UIButton!
    @IBOutlet weak var soldLab: UILabel!
    @IBOutlet weak var dontLab: UILabel!
    @IBOutlet weak var dnBtn: UIButton!
    @IBOutlet weak var cnclBtn: UIButton!
    @IBOutlet weak var navigate: UINavigationBar!
    
    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    var myAds = [MyAds]()
    fileprivate var selectedCell = ""
    
    fileprivate var rowHieght: CGFloat = 153.0
    
    var selectedtitle = ""
    var selectedCity = ""
    var selectedDate = ""
    var selectedPrice = ""
    var selectedContent = ""
    var selectedPhone = ""
    var selectedShare = ""
    var selectedAdId = ""
    var selectedUserId = ""
    var selectedDis = ""
    var selectedTyp = ""
    var selectedImgs = [String]()
    var selectedCode = ""
    var selectedIndex = ""
    var selectedImages = [UIImage]()
    var selectedLink = ""
   // var indxPath: IndexPath = []
   // var tappedId: [String] = []
    var tappedId:String=""
    var tappedRow: IndexPath = []
    var dele = "\(1)"

    var pageNo:Int=1
    var limit:Int=10
    var totalPages:Int=1
    
    var tr:Bool = false
    
    var isCurrentLoad:Bool=false
    var isLastLoad:Bool=false
    
    private var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeVC.statusBar()
         self.configLocalization()
          LogInVC.shared.hudStart()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.bgView.alpha = 0
        self.msgView.alpha = 0
        msgView.layer.cornerRadius = 20.0
        msgView.clipsToBounds = true
        
       
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        DispatchQueue.main.async {
            self.current(pageNo: self.pageNo)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        
    }
    
    
    @objc func refresh()
    {
        
        refreshControl.endRefreshing()
        if tr == false {
            self.current(pageNo: self.pageNo )
        } else {
            self.last(pageNo: self.pageNo)
        }
        
       
    }

   
    @IBAction func unwindBtn(_ sender: Any) {
        performSegue(withIdentifier: "myAdsUnwind", sender: self)
        
    }
    
    @IBAction func segBtn(_ sender: Any) {
        
        if seg.selectedSegmentIndex == 0 {
            myAds.removeAll()
            self.current(pageNo: pageNo)
            self.tr = false
            } else {
            myAds.removeAll()
           self.last(pageNo: pageNo)
            self.tr = true
        }
    }
    
    
    
    @IBAction func unwindToMyAds(segue : UIStoryboardSegue ) {}
    
    
    @IBAction func soldCheckBtn(_ sender: UIButton) {
        self.audioPlayer.play()

        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.dele = "\(1)"
                self.dontCheck.isUserInteractionEnabled = false
            }, completion: nil)
        }
        self.dontCheck.isUserInteractionEnabled = true

    }
    
    @IBAction func dontCheckBtn(_ sender: UIButton) {
        self.audioPlayer.play()

        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                self.dele = "\(2)"
                self.soldCheck.isUserInteractionEnabled = false
            }, completion: nil)
        }
        self.soldCheck.isUserInteractionEnabled = true

    }
    
    @IBAction func doneBtn(_ sender: Any) {
        //\(1)
        print("tabbbbeed isss is \(tappedId)")
        
       API.deletAd(reason: "1", idsAdvertisement: tappedId) { (error: Error?, success: Bool) in
            if success {
                self.myAds.remove(at: self.tappedRow.item)
                self.tableView.deleteRows(at: [self.tappedRow], with: .automatic)
            } else {
                SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key: "plsCchkUrCon"))
                SVProgressHUD.setShouldTintImages(false)
                SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.bgView.alpha = 0
            self.msgView.alpha = 0
        }
        
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.bgView.alpha = 0
            self.msgView.alpha = 0
        }
        
    }
    
    
    func current(pageNo:Int) {
        isCurrentLoad=true
        isLastLoad=false
        API.myCurAds(pageNo: pageNo, completion: { (error: Error?, data:[MyAds]?) in
            if data != nil {
                self.myAds.removeAll()
            self.myAds.append(contentsOf:data!)
            //self.tableView.reloadWithAnimation()
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                print("myAds", data!)
            }
            SVProgressHUD.dismiss()

        })
    }


    func last(pageNo: Int) {
        isCurrentLoad=false
        isLastLoad=true
        
        API.myOldAds(pageNo: pageNo, completion: { (errpr: Error?, data: [MyAds]?) in
            if data != nil {
                self.myAds.removeAll()
             self.myAds.append(contentsOf: data!)
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
            SVProgressHUD.dismiss()

        })
        
    }
    
    
    func configLocalization() {
        navigate.topItem?.title = General.stringForKey(key: "myAds")
        self.soldCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.soldCheck.setImage(UIImage(named:"che2"), for: .selected)
        self.dontCheck.setImage(UIImage(named:"che1"), for: .normal)
        self.dontCheck.setImage(UIImage(named:"che2"), for: .selected)
        
        self.seg.setTitle(General.stringForKey(key: "current"), forSegmentAt: 0)
        self.seg.setTitle(General.stringForKey(key: "last"), forSegmentAt: 1)
        
        self.deletLab.text = General.stringForKey(key: "delet")
        self.soldLab.text = General.stringForKey(key: "sold item")
        self.dontLab.text = General.stringForKey(key: "don't sell anymore")
        self.dnBtn.setTitle(General.stringForKey(key: "done"), for: .normal)
        self.cnclBtn.setTitle(General.stringForKey(key: "cancel"), for: .normal)
    }
    
    
    
    

}
extension MyAdsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAds.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdCell", for: indexPath) as! MyAdsCell
        
          cell.pics = myAds[indexPath.item]
          cell.title.text = myAds[indexPath.row].Advtitle
          cell.date.text = "قبل"+myAds[indexPath.row].advertisement_date
          cell.city.text = myAds[indexPath.row].city
          cell.price.text = myAds[indexPath.row].advertisement_price
          cell.id.text = myAds[indexPath.row].adId
          let advType = myAds[indexPath.row].advertisement_type
        if advType == "1"
        {
            cell.kind.text = "New"
        }else if advType == "2"{
            cell.kind.text = "used"
            cell.kind.backgroundColor = UIColor.gray
        } else {
            cell.kind.text = "none"
            cell.kind.backgroundColor = UIColor.gray
        }
        
        
            cell.delegate = self
            cell.tag = indexPath.row
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHieght
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let  selected = myAds[indexPath.row]
        self.selectedCell = "\(selected)"
        selectedCity = myAds[indexPath.row].city
        selectedPhone = myAds[indexPath.row].phone
        selectedtitle = myAds[indexPath.row].Advtitle
        selectedContent = myAds[indexPath.row].content
        selectedPrice = myAds[indexPath.row].advertisement_price
        selectedCode = myAds[indexPath.row].advertisement_code
        selectedTyp = myAds[indexPath.row].advertisement_type
        selectedAdId = myAds[indexPath.row].adId
        selectedShare = myAds[indexPath.row].share
        selectedImgs = myAds[indexPath.row].phots
        
        performSegue(withIdentifier: "MyAdContentSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyAdContentSegue" {
            let con = segue.destination as? AdContentVC
            con?.recPrice = selectedPrice
            con?.recNum = selectedPhone
            con?.recContent = selectedContent
            con?.recCity = selectedCity
            con?.recTitle = selectedtitle
            con?.recAdId = selectedAdId
            con?.recCode = selectedCode
            con?.recShare = selectedShare
            con?.recTyp = selectedTyp
            con?.recImgs = selectedImgs
            con?.recLink = selectedLink
            con?.recPage = "myAdsPage"
               
        } else if segue.identifier == "UpdateMyAdSegue" {
            let updateAd = segue.destination as? UpdateMyAdVC
            updateAd?.recCity = selectedCity
            updateAd?.recPrice = selectedPrice
            updateAd?.recTitle = selectedtitle
            updateAd?.recContent = selectedContent
            updateAd?.recNum = selectedPhone
            updateAd?.recId = selectedAdId
            updateAd?.imgString = selectedImgs
            updateAd?.recContent = selectedContent
            
        }
    }
    
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let animation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
        if indexPath.row == myAds.count - 1 {
            
            //
             totalPages=myAds[indexPath.row].totalPages
            if  pageNo < totalPages {
                
                if isCurrentLoad == true && isLastLoad == false {
                    // call getSub
                    pageNo += 1
                    self.current(pageNo: pageNo)
                }else{
                    pageNo += 1
                    self.last(pageNo: pageNo)
                }
            }
        }
    }
    
    
    
}

extension MyAdsVC: myAdDelegate {
    
    func updateTapped(_ sender: MyAdsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
         // let cell = tableView.cellForRow(at: tappedIndexPath) as! MyAdsCell
        selectedContent = myAds[tappedIndexPath.row].content
        selectedImgs = myAds[tappedIndexPath.row].phots
        selectedPhone = myAds[tappedIndexPath.row].phone
        selectedPrice = myAds[tappedIndexPath.row].advertisement_price
        selectedCity=sender.city.text!
        //selectedPrice=sender.price.text!
        selectedtitle=sender.title.text!
        selectedAdId=sender.id.text!
        
//         print("sender.city \(sender.city.text!)")
//         print("sender.city \(sender.id.text!)")
//         print("sender.price \(sender.price.text!)")
         performSegue(withIdentifier: "UpdateMyAdSegue", sender: self)
    }
    
    func deletTapped(_ sender: MyAdsCell) {
      guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tappedIndexPath \(tappedIndexPath.item)")
        
       self.tappedRow = tappedIndexPath
       let indx = myAds[tappedIndexPath.row].id_advertisement
        print("tapped",indx)
      //  self.tappedId.append(indx)
          tappedId=indx
          self.msgView.alpha = 1.0
          self.bgView.alpha = 1.0
          self.msgView.transform = CGAffineTransform(scaleX: 0.3, y: 1)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options:.curveEaseOut, animations: {
               self.msgView.transform = .identity
          }, completion: nil)
    }
    
    
}

//extension MyAds: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    
//        func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//            return UIImage(named: "empg.png")
//           }
//    
//        func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//            let str = "No Ads Found"
//            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
//            return NSAttributedString(string: str, attributes: attrs)
//        }
//    
//        func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//            let str = "search between awsome deals 😍 and connect with sellers"
//            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
//            return NSAttributedString(string: str, attributes: attrs)
//        }
//    
//}
//
//









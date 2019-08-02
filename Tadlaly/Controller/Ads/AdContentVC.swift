//
//  AdContentVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/25/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import AVFoundation
import ImageSlideshow
import Kingfisher
import SVProgressHUD
import Alamofire
import SwiftyJSON


class AdContentVC: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var detailsView: UITextView!
    @IBOutlet weak var float: UIView!
    @IBOutlet weak var floatCard: UIView!
    @IBOutlet weak var codeTF: UILabel!
    @IBOutlet weak var priceTF: UILabel!
    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var kindTF: UILabel!
    @IBOutlet weak var titleTF: UILabel!
    @IBOutlet weak var cityTF: UILabel!
    @IBOutlet weak var shareTF: UILabel!
    @IBOutlet weak var bar: UITabBar!
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var shareImg: UIImageView!
    
    
    
   fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
   fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var imgSource = [InputSource]()

    
    var recView_count=""
     var recCity = ""
      var recTitle = ""
       var recContent = ""
        var recPrice = ""
       var recDate = ""
      var recKind = ""
     var recCode = ""
    var recNum = ""
     var recShare = ""
      var recAdId = ""
       var recUserId = ""
      var recOwner = ""
     var imageIndex=""
    var recImgs = [String]()
     var recLink = ""
    var recAdvertisement_user:String = ""
    
        var recPage = ""
       var recIdAdv = ""
      var recShoPh = ""
     var recTyp = ""
    var array:[String] = []
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeVC.statusBar()

        print(recCity)
        uploadShare()
        configLoca()
          displayData()
           displayDesign()
            configSliderShow()
             readStatus()
        
        DispatchQueue.main.async {
            for da in self.recImgs {
                self.imgSource.append(KingfisherSource(urlString: da)!)
            }
            self.slideshow.setImageInputs(self.imgSource)
        }
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
       self.bar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AdContentVC.imageTapped(gesture:)))
        shareImg.addGestureRecognizer(tapGesture)
        
        shareImg.isUserInteractionEnabled = true
      
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
        //    print("Image Tapped")
            let activityVC = UIActivityViewController(activityItems: ["Tadlaly://\(recLink)"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    
    
    
    
  
    
    
    
    

    @IBAction func bckBtn(_ sender: Any) {
        if recPage == "adsPage" {
                performSegue(withIdentifier: "unwindAds", sender: self)

        } else if recPage == "searchPage" {
                performSegue(withIdentifier: "unwindSearch", sender: self)

        }
        else if recPage == "myAdsPage" {
                performSegue(withIdentifier: "unwindMyAds", sender: self)
        } else if recPage == "followPage" {
            performSegue(withIdentifier: "unwindFollow", sender: self)

        }
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatSegue" {
            let sb = segue.destination as? ChatVC
            sb?.recNum = recNum
            sb?.recToUser = recUserId
            sb?.recName = recOwner
        }

    }
    
    func uploadShare() {
        API.count(idAdv: recIdAdv , count: "2") { (error: Error?, success: Bool?) in
            if success! {
                print("success share")
            } else {
                print("faild share")
            }
        }
    }

    
        func AlertPopUP(title: String, message: String ) {
        
             let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: General.stringForKey(key: "ok"), style: .default,     handler: { (action) in
                 alert.dismiss(animated: true, completion: nil)
              }))
              self.present(alert, animated: true, completion: nil)
                    }
   
    
    func configLoca() {
        self.nav.topItem?.title = General.stringForKey(key: "adContent")
        if let bar  = bar.items {
            bar[0].title = General.stringForKey(key: "call")
            bar[1].title = General.stringForKey(key: "whatsapp")
            bar[2].title = General.stringForKey(key: "chat")
        }
    }
    
    
    func configSliderShow() {
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        slideshow.pageIndicator = pageControl
        
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.activityIndicator = DefaultActivityIndicator(style: .gray , color: nil )
        
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(AdContentVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
        
        slideshow.addSubview(pageControl)
        
    }
    
    func displayData() {
        self.titleTF.text = recTitle
        self.cityTF.text = recCity
        self.dateTF.text = recDate
        self.detailsView.text = recContent
        self.priceTF.text = recPrice
        self.shareTF.text = recShare
        self.codeTF.text = recAdId
        self.countLabel.text = recView_count
        
        if recTyp == "1" {
            self.kindTF.text = "new"
        } else if recTyp == "2" {
            self.kindTF.backgroundColor = UIColor.gray
            self.kindTF.text = "used"
        } else {
            self.kindTF.text = "none"
            self.kindTF.backgroundColor = UIColor.gray
        }
        
    }
    
    func displayDesign() {
        self.float.layer.cornerRadius = 10
        self.float.layer.shadowColor = UIColor.clear.cgColor
        self.float.layer.shadowRadius = 5
        self.float.layer.shadowOpacity = 1
        self.float.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.kindTF.layer.cornerRadius = 10
        self.kindTF.layer.shadowColor = UIColor.darkGray.cgColor
        self.kindTF.layer.shadowRadius = 5
        self.kindTF.layer.shadowOpacity = 1
        self.kindTF.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.slideshow.floaat()
        self.detailsView.floaat()
        self.floatCard.floaat()
        
    }
    
    func readStatus() {
        API.readedAd(adId:  Int(recAdId)! , userId: helper.getApiToken(), status: "read") { (error:Error, success:Bool?) in
            if success == true {
                print("doRead success")
            } else {
                print("doRead faild")
            }
        }
    }
    
   
}
extension AdContentVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0) {
         audioPlayer.play()
            if "\(helper.getApiToken())" == recAdvertisement_user {
                
            } else {
                if helper.getUserData() == true {
                    performSegue(withIdentifier: "ChatSegue", sender: self)
                } else {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: "you need to login to access")
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 4.0)
                }
            }
            
            
        } else if (item.tag == 1) {
            audioPlayer.play()
            if recAdvertisement_user == "\(helper.getApiToken())" {

            } else {
             //   let msg = "السلام عليكم بخصوص اعلانك علي تطبيق تدللي \(self.recTitle)\(self.recCode)"
                if self.recNum != "" {
                    print(recNum)
                   // let appURL = NSURL(string: )!
        let urlw = URL(string: "https://api.whatsapp.com/send?phone=\(self.recNum)")
                    print(urlw!)
                    if UIApplication.shared.canOpenURL(urlw!) {
                      //  if #available(iOS 10.0, *) {
                            UIApplication.shared.open(urlw! , options: [:], completionHandler: nil)
                      //  }
//                        else {
//                            UIApplication.shared.openURL(appURL as URL)
//                        }
                    }
                    else {
                        AlertPopUP(title: General.stringForKey(key: "err"), message: General.stringForKey(key: "installwts"))
                        // Whatsapp is not installed
                    }
                    
                } else {
                    
                }
            }
        } else if (item.tag == 2) {
            audioPlayer.play()
            if "\(helper.getApiToken())" == recAdvertisement_user {
                
            } else {
                if let url = URL(string: "tel://\(recNum)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
              }
            }
           }
    
    
}
extension UIView{
    func floaat() {

        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
}









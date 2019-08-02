
import UIKit
import AVFoundation
import Kingfisher
import CoreLocation
import Alamofire
import SwiftyJSON
import ImageSlideshow
import SVProgressHUD
import UPCarouselFlowLayout
import Alamofire
import SwiftyJSON




class HomeVC: UIViewController, UIScrollViewDelegate , SWRevealViewControllerDelegate {

    @IBOutlet weak var cateCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    @IBOutlet weak var menuBarBtn: UIBarButtonItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var slider: ImageSlideshow!
    @IBOutlet weak var offerTitleLab: UILabel!
    @IBOutlet weak var offerContentLabel: UILabel!
    @IBOutlet weak var nxBtn: UIButton!
    @IBOutlet weak var prevsBtn: UIButton!
    @IBOutlet weak var navi: UINavigationBar!
    

    
    fileprivate let tapSound = Bundle.main.url(forResource: "tap", withExtension: "wav")
    fileprivate var audioPlayer = AVAudioPlayer()
    
    fileprivate var slidData = [SlidShowData]()
    
    var mainNameSelect="1"
    var subAd = [Ad]()
    
    
    fileprivate var locationManager:CLLocationManager!
    fileprivate var longTuide = ""
    fileprivate var latitude = ""
    
    fileprivate var imgSource = [InputSource]()
    fileprivate var selectedIndexPath = IndexPath()
    
    
    var selectedSub = ""
   // var BRANCHNAME = ""
    var BRANCHNAME:String?
    var depaId = ""
    var  txtAr = ""
    var txtEn = ""
    
    
    var onceOnly = false


    var inddx:Int = 0
    
    var categoryData = [CategoriesDep]()
    var branchData = [subData]()
    var newData = [CategoryDep]()
    
    var branchNameSelect = ""
    
    var currePage=0
    var prevPage=0
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        if helper.getUserData() == true {
    //            updateToken()
    //        } else {
    //            print("he is a guest")
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let not = UIImage(named: "nota.png")!

        
        SVProgressHUD.dismiss()
        self.hideNavigationShadow(viwController: self)
        
       

        // cateCollectionView.semanticContentAttribute = .forceRightToLeft
        // subCollectionView.semanticContentAttribute = .forceRightToLeft
       // self.navigationItem.rightBarButtonItems = [menuBarBtn, notiBtn ]
        
         let notiBtn  = UIBarButtonItem(image: UIImage(named: "nota.png"),  style: .plain, target: self, action: #selector(notiTapped))
    
        
        notiBtn.image = UIImage(named: "nota.png")
        notiBtn.tintColor = UIColor.white
        
//        if Locale.current.languageCode == "ar" {
//            navi.topItem?.rightBarButtonItems = [notiBtn,menuBarBtn]
//            navi.semanticContentAttribute = .forceLeftToRight
//        } else  {
//            navi.topItem?.rightBarButtonItems = [menuBarBtn, notiBtn]
//            navi.semanticContentAttribute = .forceLeftToRight
//
//        }
        navi.topItem?.rightBarButtonItems = [notiBtn,menuBarBtn]
        navi.semanticContentAttribute = .forceLeftToRight

        
        
        HomeVC.statusBar()
        configSWRevealVC()
        configSlierShow()
        configFlowLayOut()
        configLocalization()
        configProtocls()
        getShareTxt()
        //updateToken()
        LogInVC.shared.hudStart()
        self.nxBtn.alpha = 0
        self.prevsBtn.alpha = 0
        slid()
        DispatchQueue.main.async {
            self.sub()
        }
        slider.corner()
        
        self.navigationController?.isNavigationBarHidden = true
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tapSound!)
        } catch {
            print("faild to load sound")
        }
        
        
    }
    
    
    @objc func notiTapped(sender: AnyObject) {
      //  print("noooota")
        performSegue(withIdentifier: "rr", sender: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        
        
        
        
    }
    
    
    @IBAction func nextBtn(_ sender: Any) {
        audioPlayer.play()
        
        
        //
        //        let visibleItems: NSArray = self.cateCollectionView.indexPathsForVisibleItems as NSArray
        //        let currentItem: IndexPath = visibleItems.object(at: 0 ) as! IndexPath
        
        //      //  let nextItem : IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        //        let nextItem : IndexPath = IndexPath(item: currentPage + 1, section: 0)
        //
        //
        //        print("visable \(visibleItems)")
        //        print("currentItem \(currentItem)")
        //        print("nextItem \(nextItem)")
        //        print("currentPage in arrow \(currentPage)")
        //        if nextItem.row < categoryData.count {
        //            print("nextItem.item\(nextItem.item)")
        //            print("nextItem.row\(nextItem.row)")
        //            self.cateCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        //            self.selectedIndexPath  = nextItem
        //            cateCollectionView.performBatchUpdates(nil, completion: nil)
        //            }
        
        //    UIScreen.main.bounds.size.width - 200.0
        //currePage
        
        if currePage < categoryData.count - 1{
            
            currePage += 1
            prevPage += 1
            self.cateCollectionView.contentOffset.x += 200
//            print("currennt page \(currePage)")
//            print("categoryData \(newData.count)")
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
           // print("page number = \(self.currePage)")
            let character = self.categoryData[self.currePage]
            let id = character.depId
            self.mainNameSelect=id
          //  print("mainNameSelect \(self.mainNameSelect)")
            self.branches(id: id)
           // print(cateCollectionView.contentOffset.x)
        }
        
    }
    
    
    @IBAction func prevBtn(_ sender: Any) {
        audioPlayer.play()
        //        let visibleItems: NSArray = self.cateCollectionView.indexPathsForVisibleItems as NSArray
        //        let currentItem: IndexPath = visibleItems.object(at: 0 ) as! IndexPath
        //        let nextItem : IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        //        if nextItem.row < categoryData.count && nextItem.row >= 0  {
        //            self.cateCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
        //            self.selectedIndexPath  = nextItem
        //            cateCollectionView.performBatchUpdates(nil, completion: nil)
        //            }
        
        
        
       // print("prev = \(prevPage)")
        // if prevPage < categoryData.count && prevPage > 0 {
        
        if prevPage < categoryData.count && prevPage > 0 {
            
           // print("current page -    \(prevPage)")
            prevPage -= 1
            currePage -= 1
            self.cateCollectionView.contentOffset.x -= 200
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: nil)
          //  print("page number = \(self.prevPage)")
            let character = self.categoryData[self.prevPage]
            let id = character.depId
            self.mainNameSelect=id
          ///  print("mainNameSelect \(self.mainNameSelect)")
            self.branches(id: id)
        //    print(cateCollectionView.contentOffset.x)
            
        }
    }
    
    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    static func statusBar () {
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {return}
        statusBarView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.03921568627, blue: 0.4392156863, alpha: 1)
        //.withAlphaComponent(0.87)
    }
    
    func slid() {
        API.slidShowCate { (error:Error? , data:[SlidShowData]?) in
            if data != nil {
                self.slidData = data!
                for data in data! {
                    self.imgSource.append(KingfisherSource(urlString: data.img)!)
                }
                self.slider.setImageInputs(self.imgSource)
            } else {
           //     print("no data")
            }
        }
    }
    
    func sub() {
        API.categoryDep { (error: Error?, data: [CategoriesDep]?) in
            if data != nil {
                self.categoryData = data!
                self.cateCollectionView.reloadData()
                guard  let ind = self.categoryData.first  else {return}
               // print (ind.depId)
                self.branches(id:ind.depId)
                self.nxBtn.alpha = 1.0
                self.prevsBtn.alpha = 1.0
                SVProgressHUD.dismiss()
            } else {
             //   print("no data")
            }
        }
    }
    
    
    func getCate() {
        
        API.categories { (error:Error?, data:[CategoryDep]?) in
            if data != nil {
                for da in data! {
                    self.newData.append(da)
                    self.cateCollectionView.reloadData()
                    self.subCollectionView.reloadData()
                    SVProgressHUD.dismiss()
                }
            } else {
                SVProgressHUD.dismiss()
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
//                    print(json)
//                    print("callllll")
//                    print("daaaaaa \(id)")
//
                    if let dataArr = json.array
                    {
                        for dataArr in dataArr {
                            let mainId=dataArr["main_department_id"].string
                           // print("main \(String(describing: mainId))")
                            
                            if  id == mainId  {
                              //  print("ss id \(id)")
                                
                                if let dataArr = dataArr["sub_depart"].array
                                {
                               //     print("inside")
                                    
                                    for dataArr in dataArr {
                                        
                                        let id = dataArr ["sub_department_id"].string
                                        
                                        
                                        let name = dataArr ["sub_department_name"].string
                                        let icon = dataArr ["sub_department_image"].string
                                      //  print("it is \(id!)")
                                     //   print("name \(name!)")
                                        // create Ream Object
                                        self.branchData.append(subData(subName: name!, subImage: icon!, subId: id!))
                                        
                                    }
                                    UIView.transition(with: self.subCollectionView, duration: 0.5, options: .transitionFlipFromTop , animations: {
                                        //Do the data reload here
                                        self.subCollectionView.reloadData()
                                    }, completion: nil)
                                    
                                    //self.subCollectionView.reloadData()
                                }
                                
                            }
                        }}
                }
        }
    }
    
    
    
//    func updateToken() {
//        if helper.getUserData() == true {
//            if helper.getToken().isEmpty == false {
//                print("tooken = \(helper.getToken())")
//                API.userTokenId(id: helper.getToken()) { (error:Error?, success: Bool) in
//                    if success {
//                        // print("success update token")
//                    } else {
//                        //  print("error to upload userToken")
//                    }
//                }
//            }
//        } else {
//           // print("he is a guest")
//        }
//    }
    
    
    func configSlierShow() {
        
        self.slider.slideshowInterval = 5.0
        self.slider.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        self.slider.contentScaleMode = UIView.ContentMode.scaleToFill
        
        self.slider.pageIndicator = LabelPageIndicator()
        self.slider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        slider.pageIndicator = pageControl
        
        self.slider.activityIndicator = DefaultActivityIndicator()
        self.slider.activityIndicator = DefaultActivityIndicator(style: .gray , color: nil )
        
        self.slider.currentPageChanged = { page in
            print("current page:", page)
            let da = self.slidData[page]
            self.offerTitleLab.text = da.imageTitle
            self.offerContentLabel.text = da.imageContent
        }
        self.slider.addSubview(pageControl)
        self.slider.addSubview(offerTitleLab)
        self.slider.addSubview(offerContentLabel)
    }
    func configSWRevealVC() {
        self.revealViewController()?.delegate = self
        if self.revealViewController() != nil {
            menuBarBtn.target = self.revealViewController()
            //  menuBarBtn.action = #selector(SWRevealViewController.revealToggle(_:))
             menuBarBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    func configFlowLayOut() {
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 180.0, height: cateCollectionView.frame.size.height)
        // layout.itemSize = CGSize(width: UIS , height: cateCollectionView.frame.size.height)
        layout.scrollDirection = .horizontal
        layout.sideItemAlpha=0.7
        layout.sideItemScale=0.7
        layout.spacingMode = .fixed(spacing: 3.0)
        //layout.sideItemShift = 0.0
        self.cateCollectionView.collectionViewLayout = layout
    }
    
    
    func configLocalization() {
        
        self.navi.topItem?.title = General.stringForKey(key: "home")
        if let bar  = tabBar.items {
            bar[0].title = General.stringForKey(key: "share")
            bar[1].title = General.stringForKey(key: "all")
            bar[2].title = General.stringForKey(key: "search")
        }
    }
    
    
    func configProtocls() {
        self.cateCollectionView.delegate=self
        self.cateCollectionView.dataSource=self
        self.subCollectionView.dataSource = self
        self.subCollectionView.delegate = self
        self.tabBar.delegate = self
    }
    
    
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            //  let character = self.items[self.currentPage]
            //print("page number = \(currentPage)")
            let character = self.categoryData[self.currentPage]
            // let character = self.newData[self.currentPage]
            let id = character.depId
            mainNameSelect=id
           // print("mainNameSelect \(mainNameSelect)")
            branches(id: id)
            
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.cateCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    //    fileprivate var orientation: UIDeviceOrientation {
    //        return UIDevice.current.orientation
    //    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.cateCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    func getShareTxt() {
        
        let url = URLs.sharedText
        Alamofire.request(url, method: .post).validate(statusCode: 200..<300).responseJSON { (response) in
            
            if ((response.result.value) != nil ) {
                let jsonData = JSON(response.result.value!)
                let s = (jsonData["ar"].string)!
                self.txtAr = s
                let d = (jsonData["en"].string)!
                self.txtEn = d
//                print("finallllllllllly",self.txtAr)
//                print("finnaaaaally",self.txtEn)
//                print(s)
//                print(d)
            } else{
              //  print("faild")
            }
            
            //            switch response.result {
            //            case.failure(_):break
            //            case.success(let value):
            //                let va = JSON(value)
            //                 print(va)
            //                if General.CurrentLanguage() == "ar" {
            //                    self.txtAr = va["ar"].string!
            //                    print(self.txtAr)
            //                    self.txtEn = va["en"].string!
            //                    print(self.txtEn)
            
            //            }
        }
    }
    
    
    
    func openActivityController() {
        print("arrrrabic", txtAr)
        print("ennnnnnnnnglish", txtEn)
        if helper.getUserData() == true {
            
            if General.CurrentLanguage() == "ar" {
                let activityVC = UIActivityViewController(activityItems: [ txtAr ,  URLs.appShare], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        return
                    }
                    // self.shareApp(userId: helper.getApiToken())
                  //  print("shhhare complete")
                }
            } else {
                let activityVC = UIActivityViewController(activityItems: [ txtEn ,  URLs.appShare], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        return
                    }
                    //  self.shareApp(userId: helper.getApiToken())
                    
                  //  print("shhhare complete")
                }
            }
        } else {
            
            if General.CurrentLanguage() == "ar" {
                let activityVC = UIActivityViewController(activityItems: [ txtAr ,  URLs.main], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        return
                    }
                    //  self.shareApp(userId: 0)
                  //  print("shhhare complete")
                }
            } else {
                let activityVC = UIActivityViewController(activityItems: [ txtEn ,  URLs.main], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                  //      print("share didnt taaaped")
                        // handle task not completed
                        return
                    }
                    //  self.shareApp(userId: 0)
                    
                  //  print("shhhare complete")
                }
            }
        }
    }
    
    
    
    func shareApp(userId:Int) {
        API.share(id: userId) { (error: Error?, success: Bool?) in
            if success! {
               // print("success to share app")
            } else {
              //  print("error to share app")
            }
        }
    }
    
    
    
    
    
    
    
    
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cateCollectionView {
            // return newData.count
            return categoryData.count
        } else {
            
            return branchData.count
            //return newData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cateCollectionView {
            let cell = cateCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            
            cell.pics = categoryData[indexPath.item]
            cell.cateName.text = categoryData[indexPath.row].depName
            //  cell.title=categoryData[indexPath.row]
            //  cell.pics = newData[indexPath.item]
            // cell.cateName.text = newData[indexPath.row].depName
            
            
            // cell.categoryName.text = categoryData[indexPath.row].depName
            return cell
        } else {
            let cell = subCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! SubCell
            
            cell.subNm.text = branchData[indexPath.row].subName
            //cell.subNm.text = newData[indexPath.row].subName
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cateCollectionView {
            
            self.depaId = categoryData[indexPath.row].depId
            self.inddx = 1
            performSegue(withIdentifier: "AdSegue", sender: self)
        }
        else  if collectionView == subCollectionView {
            
            
           // print("select")
            branchNameSelect =  mainNameSelect
         //   print("branchNameSelect \(branchNameSelect)")
            BRANCHNAME=branchData[indexPath.row].subId
            self.inddx = 2

            // BRANCHNAME = categoryData[indexPath.row].subId
            
            performSegue(withIdentifier: "AdSegue", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdSegue" {
            let homevC = segue.destination as? AdsVC
            print("branchNameSelect \(branchNameSelect)")
            homevC?.recSubTapped =  "selected"
//            if BRANCHNAME == "" {
//                print("ffff",branchData[0].subId!)
//                BRANCHNAME = branchData[0].subId
//            } else {
                homevC?.recIddx = inddx
                homevC?.branchName=BRANCHNAME ?? ""
           // }
            homevC?.mainName=mainNameSelect
            homevC?.recDepId = depaId
            homevC?.recDepa = depaId
        } else if segue.identifier == "rr" {
            let fo = segue.destination as? MyFollowersVC
               fo?.recPag = "r"
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView ==  cateCollectionView{
            
            //            let id = categoryData[indexPath.row].depId
            //            mainNameSelect=id
            //            print("mainNameSelect \(mainNameSelect)")
            //            branches(id: id)
            //        if !onceOnly {
            //            let indexToScrollTo = IndexPath(item: 0, section: 0)
            //            self.cateCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            //            onceOnly = true
            //          }
        }
    }
    
    
    
    
    
    
}
extension HomeVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1) {
            //print("1")
            audioPlayer.play()
            openActivityController()
        } else if (item.tag == 2){
            audioPlayer.play()
            //AdAllSegue
            //performSegue(withIdentifier: "AdSegue", sender: self)
            performSegue(withIdentifier: "AdAllSegue", sender: self)
            
        } else if (item.tag == 3) {
            audioPlayer.play()
            performSegue(withIdentifier: "SearchSegue", sender: self)
            
        }
        
    }
    
}


extension HomeVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation
        
        self.longTuide = "\(userLocation.coordinate.longitude)"
        self.latitude = "\(userLocation.coordinate.latitude)"
        print(self.longTuide)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in Geocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                //print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
}



extension UIView {
    func corner() {
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
    }
}









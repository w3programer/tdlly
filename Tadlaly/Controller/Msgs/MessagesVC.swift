//
//  MessagesVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/30/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class MessagesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: UINavigationBar!
    
    var msgs = [Message]()
    fileprivate var ids = [""]
    fileprivate var numId = ""
    fileprivate var cellHeight: CGFloat = 100.0
    
    var recToUserId = ""
    var recName = ""
    var recNum = ""
    var recFromUserId=""
    var recImg = ""
    
    var pageNo:Int=1
    var limit:Int=10
    var totalPages:Int=1 //pageNo*limit
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HomeVC.statusBar()
        
        self.navi.topItem?.title = General.stringForKey(key: "messages")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
//        if API.isConnectedToInternet() {
            DispatchQueue.main.async {
                self.getMsgs(pageNo: self.pageNo)
            }
//        } else {
//           LogInVC.shared.showAlert(title: General.stringForKey(key: "conWeak"), message: General.stringForKey(key: "plsCchkUrCon"))
//        }
//
        
      }

    
    @IBAction func baackBtn(_ sender: Any) {
        performSegue(withIdentifier: "msgsUnwind", sender: self)

    }
    
    func getMsgs(pageNo:Int)   {
        API.showAllMsgs(pageNo: pageNo) { (error: Error?, data: [Message]?) in
            if data != nil {
                self.msgs = data!
                DispatchQueue.main.async {
                    self.tableView.reloadWithAnimation()
                }
                print(data!)
            }
            
        }
    }
    

    
  
}
extension MessagesVC: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MsgsCell", for: indexPath) as! MessagesCell
        
        cell.pics = msgs[indexPath.item]
        cell.msg.text = msgs[indexPath.row].MsgContent
        cell.name.text = msgs[indexPath.row].fromName
        cell.time.text = msgs[indexPath.row].msgTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            print("message id is \(msgs[indexPath.row].messageId)")
                
            API.deletAllMsgs(idsMsgs: msgs[indexPath.row].messageId,completion:  { (error:Error?, success:Bool?) in
                
                if success! {
                    self.msgs.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    SVProgressHUD.show(UIImage(named: "er.png")!, status: General.stringForKey(key:"plschkUrCon"))
                    SVProgressHUD.setShouldTintImages(false)
                    SVProgressHUD.setImageViewSize(CGSize(width: 40, height: 40))
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 20.0))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
            })
                
                
                
            
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        recFromUserId=msgs[indexPath.row].fromId
        recToUserId = msgs[indexPath.row].toId
        recName = msgs[indexPath.row].fromName
        recNum = msgs[indexPath.row].fromNum
        
        performSegue(withIdentifier: "ShowMsg", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == msgs.count - 1 { //
            
            
            if  pageNo < totalPages {
                pageNo += 1
                //  loadData(pageNumber: pageNo)
                getMsgs(pageNo: pageNo)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMsg" {
            
            
            print("message to id \(recToUserId)")
            print("message from id \(recFromUserId)")
            let vc = segue.destination as? ChatVC
           // vc?.recToUser = recToUserId

            vc?.recToUser = recFromUserId
            vc?.recNum = recNum
            vc?.recName = recName
        }
    }
    
}

extension MessagesVC: DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empInbx.png")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Inbox Empty"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "search between awsome deals 😍 and connect with sellers"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}

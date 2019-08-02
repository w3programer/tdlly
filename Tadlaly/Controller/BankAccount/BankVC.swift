//
//  BankVC.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 3/27/19.
//  Copyright © 2019 MahmoudHajar. All rights reserved.
//

import UIKit
import SVProgressHUD


class BankVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    fileprivate var bankArr = [BankAccounts]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

                bankData()
             confirTableView()
       LogInVC.shared.hudStart()
        
        
        

    }
    
    @IBAction func bakBtn(_ sender: Any) {
        performSegue(withIdentifier: "accUnwind", sender: self)
        
    }
    
  fileprivate func confirTableView() {
        
        tableView.delegate = self
         tableView.dataSource = self
          tableView.tableFooterView = UIView()
            tableView.tableFooterView?.tintColor = UIColor.clear
    }
    
   fileprivate func bankData(){
        API.BankAccountsApi{(error :Error?, data: [BankAccounts]?) in
            if data != nil {
                self.bankArr = data!
                self.tableView.reloadWithAnimation()
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
                print("no data")
            }
           // SVProgressHUD.dismiss(withDelay: 1.0)
        }
        
    }

}
extension BankVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bankArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BankAccountCell
        
        cell.bankLab.text = bankArr[indexPath.row].account_bank_name
         cell.bankLabel.text = bankArr[indexPath.row].account_name
          cell.numLab.text = bankArr[indexPath.row].account_number
           cell.ibanLab.text = bankArr[indexPath.row].account_IBAN
          
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let animation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)

    }
    
    
    
    
}

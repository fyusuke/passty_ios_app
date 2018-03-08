//
//  LeftViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/27.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {
    
    @IBAction func PasstyBtn(_ sender: UIButton) {
        if let _ = UserDefaults.standard.object(forKey: "access_token"){
            if let start_date = UserDefaults.standard.object(forKey: "start_date") as? Date {
                if Date() > start_date {
                    self.performSegue(withIdentifier: "toPasstyListFromLeftMenuSegue", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "toBeforeStartDateLeftMenuSegue", sender: nil)
                }
            } else {
                self.performSegue(withIdentifier: "toUnContractedLeftMenuSegue", sender: nil)
            }
        } else {
            self.performSegue(withIdentifier: "toLoginLeftMenuSegue", sender: nil)
        }
    }
    @IBAction func settingBtn(_ sender: UIButton) {
    }
    @IBAction func updateAppBtn(_ sender: UIButton) {
    }
    @IBAction func AskBtn(_ sender: UIButton) {
    }
    @IBAction func termOfServiceBtn(_ sender: UIButton) {
    }
    @IBAction func logoutBtn(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

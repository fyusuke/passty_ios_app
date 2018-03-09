//
//  MainViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/27.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var PasttyListPage: UIView!
    @IBOutlet weak var BeforeStartDatePage: UIView!
    @IBOutlet weak var UnContractedPage: UIView!
    @IBOutlet weak var GrayOverlayPage: UIView!
    var sideMenuOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GrayOverlay), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        self.GrayOverlayPage.alpha = 0.0

        if let s_start_date = UserDefaults.standard.object(forKey: "start_date") as? String {
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "ja_JP")
            dateFormater.dateFormat = "yyyy-MM-dd"
            let start_date = dateFormater.date(from: s_start_date)!
            if start_date < Date() {
                print("in service")
                PasttyListPage.isHidden = false
                BeforeStartDatePage.isHidden = true
                UnContractedPage.isHidden = true
            } else {
                print("before start data")
                PasttyListPage.isHidden = false
                BeforeStartDatePage.isHidden = true
                UnContractedPage.isHidden = true
            }
        } else {
            print("uncontracted")
            PasttyListPage.isHidden = true
            BeforeStartDatePage.isHidden = true
            UnContractedPage.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showDetectionSettings),
                                               name: NSNotification.Name("ShowDetectionSettings"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showFetchNewInfoPage),
                                               name: NSNotification.Name("ShowFetchNewInfoPage"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showContactUsPage),
                                               name: NSNotification.Name("ShowContactUsPage"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showTermOfService),
                                               name: NSNotification.Name("ShowTermOfService"),
                                               object: nil)
    }
    
    @objc func showDetectionSettings(){
        performSegue(withIdentifier: "showDetectionSettings", sender: nil)
    }
    
    @objc func showFetchNewInfoPage(){
        performSegue(withIdentifier: "showFetchNewInfoPage", sender: nil)
    }
    
    @objc func showContactUsPage(){
        performSegue(withIdentifier: "showContactUsPage", sender: nil)
    }
    
    @objc func showTermOfService(){
        performSegue(withIdentifier: "showTermOfService", sender: nil)
    }

    @IBAction func tappedOnMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func GrayOverlay(){
        if self.sideMenuOpen {
            self.sideMenuOpen = false
            UIView.animate(withDuration: 0.3, animations: {
                self.GrayOverlayPage.alpha = 0.0
            })
        } else {
            self.sideMenuOpen = true
            UIView.animate(withDuration: 0.3, animations: {
                self.GrayOverlayPage.alpha = 0.7
            })
        }
    }

}

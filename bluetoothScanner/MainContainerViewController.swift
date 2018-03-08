//
//  MainContainerViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/27.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(signOut),
                                               name: NSNotification.Name("SignOut"),
                                               object: nil)
    }
    
    @objc func toggleSideMenu(){
        if sideMenuOpen {
            print("toggle is closed")
            sideMenuOpen = false
            sideMenuConstraint.constant = -240
        } else {
            print("toggle is open")
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration:0.3){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func signOut(){
        performSegue(withIdentifier: "toLoginSegue", sender: nil)
    }

}

//
//  GrayOverlayViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/28.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class GrayOverlayViewController: UIViewController {

    @IBOutlet var GrayOverlayPage: UIView!
    var sideMenuOpen = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapAction))
        self.GrayOverlayPage.addGestureRecognizer(gesture)
    }
    
    @objc func tapAction(sender : UITapGestureRecognizer) {
        if sideMenuOpen {
            self.GrayOverlayPage.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        } else {
            self.GrayOverlayPage.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        }
        UIView.animate(withDuration:0.3){
            self.view.layoutIfNeeded()
        }
    }
}

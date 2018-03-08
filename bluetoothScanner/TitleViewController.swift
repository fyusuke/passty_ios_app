//
//  TitleViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/26.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let _ = UserDefaults.standard.object(forKey: "access_token"){
                self.performSegue(withIdentifier: "toMainViewSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toLoginFromTitleSegue", sender: nil)
            }
        }
    }

}

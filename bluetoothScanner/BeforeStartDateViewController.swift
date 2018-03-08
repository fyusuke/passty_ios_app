//
//  MainViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/27.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class BeforeStartDateViewController: UIViewController {
    
    @IBOutlet weak var start_date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let s_start_date = UserDefaults.standard.string(forKey: "start_date"){
            if let _start_date = dateFormatter.date(from: s_start_date) {
                dateFormatter.dateFormat = "MM/dd HH:mm @日本時間"
                self.start_date.text = dateFormatter.string(from: _start_date)
            }
        }
    }
}

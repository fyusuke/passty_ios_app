//
//  TermOfServiceViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/03/21.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit
import WebKit

class TermOfServiceViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    let targetURL = "https://www.passty-passport-cover.com/pages/term_of_service"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddressURL()
    }
    
    func loadAddressURL() {
        let url = URL(string: targetURL)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }

}

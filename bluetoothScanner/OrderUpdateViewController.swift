//
//  OrderUpdateViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/28.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class OrderUpdateViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var updateOrderLabel: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        updateOrderLabel.layer.cornerRadius = 10.0
    }
    
    @IBAction func updateOrderAction(_ sender: Any) {
        let params: [String: String] = [
            "access_token": UserDefaults.standard.string(forKey: "access_token")!,
            ]
        updateOrderLabel.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        Alamofire.request("https://stark-earth-51396.herokuapp.com/api/v1/orders/fetch", method: .post, parameters: params).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                let json:JSON = JSON(response.result.value ?? kill)
                if let result = json["error"].string{
                    self.message.textColor = UIColor.red
                    self.message.text = result
                    self.indicator.isHidden = true
                    self.updateOrderLabel.isEnabled = true
                    self.indicator.stopAnimating()
                } else {
                    var stock_info = [[String: String]]()
                    for (_, object1) in json["stock_info"] {
                        let _temp_info = object1.dictionaryObject! as! [String: String]
                        stock_info.append(_temp_info)
                    }
                    self.userDefaults.set(json["start_date"].string, forKey: "start_date")
                    self.userDefaults.set(json["end_date"].string, forKey: "end_date")
                    //                  no access_token
                    self.userDefaults.set(stock_info, forKey: "stock_info")
                    self.message.textColor = UIColor.blue
                    self.message.text = json["success"].string
                    self.indicator.isHidden = true
                    self.updateOrderLabel.isEnabled = true
                    self.indicator.stopAnimating()
                    print(json)
                }
            case .failure(let error):
                self.message.textColor = UIColor.red
                self.message.text = "通信に失敗しました"
                self.indicator.isHidden = true
                self.updateOrderLabel.isEnabled = true
                self.indicator.stopAnimating()
                print(error)
            }
            
        })
    }

}

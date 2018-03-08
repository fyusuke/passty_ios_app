//
//  LoginViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/24.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var alartMessage: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.backgroundColor = UIColor.blue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5.0 // 角丸のサイズ
        inputEmail.delegate = self
        inputPassword.delegate = self
        indicator.isHidden = true

        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let params: [String: String] = [
            "email": inputEmail.text!,
            "password": inputPassword.text!
        ]
        loginButton.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        Alamofire.request("https://www.passty-passport-cover.com/api/v1/sessions/login", method: .post, parameters: params).responseJSON(completionHandler: { response in

            switch response.result {
            case .success:
                let json:JSON = JSON(response.result.value ?? kill)
                if let result = json["error"].string   {
                    self.alartMessage.text = result
                    self.indicator.isHidden = true
                    self.loginButton.isEnabled = true
                    self.indicator.stopAnimating()
                } else {
                    var stock_info = [[String: String]]()
                    for (_, object1) in json["stock_info"] {
                        let _temp_info = object1.dictionaryObject! as! [String: String]
                        stock_info.append(_temp_info)
                    }
                    self.userDefaults.set(json["start_date"].string, forKey: "start_date")
                    self.userDefaults.set(json["end_date"].string, forKey: "end_date")
                    self.userDefaults.set(json["access_token"].string, forKey: "access_token")
                    self.userDefaults.set(stock_info, forKey: "stock_info")
                    self.alartMessage.text = ""
                    print(json)
                    self.indicator.isHidden = true
                    self.loginButton.isEnabled = true
                    self.indicator.stopAnimating()

                    self.performSegue(withIdentifier: "toMainContainerSegue", sender: nil)
                }
            case .failure(let error):
                self.alartMessage.text = "通信に失敗しました"
                print(error)
                self.indicator.isHidden = true
                self.loginButton.isEnabled = true
                self.indicator.stopAnimating()
            }

        })
    }
}

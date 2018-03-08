//
//  ContactUsFormViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/28.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactUsFormViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var saveBtnLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        saveBtnLabel.backgroundColor = UIColor.blue
        saveBtnLabel.setTitleColor(.white, for: .normal)
        saveBtnLabel.layer.cornerRadius = 5.0
        textInput.delegate = self
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.lightGray.cgColor
        textInput.layer.cornerRadius = 5.0
    }
    
    func TextViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let params: [String: String] = [
            "access_token": UserDefaults.standard.string(forKey: "access_token")!,
            "message": textInput.text!
        ]
        saveBtnLabel.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        Alamofire.request("https://stark-earth-51396.herokuapp.com/api/v1/contact_us_forms", method: .post, parameters: params).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                let json:JSON = JSON(response.result.value ?? kill)
                if let result = json["error"].string   {
                    self.Message.textColor = UIColor.red
                    self.Message.text = result
                    self.indicator.isHidden = true
                    self.saveBtnLabel.isEnabled = true
                    self.indicator.stopAnimating()
                } else {
                    self.Message.textColor = UIColor.blue
                    self.Message.text = json["success"].string
                    self.textInput.text = ""
                    self.indicator.isHidden = true
                    self.saveBtnLabel.isEnabled = true
                    self.indicator.stopAnimating()
                    print(json)
                }
            case .failure(let error):
                self.Message.textColor = UIColor.red
                self.Message.text = "通信に失敗しました"
                self.indicator.isHidden = true
                self.saveBtnLabel.isEnabled = true
                self.indicator.stopAnimating()

                print(error)
            }
            
        })
    }
}

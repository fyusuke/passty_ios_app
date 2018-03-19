//
//  CustomCell.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/03/08.
//  Copyright © 2018年 yusuke. All rights reserved.
//


import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet var PassportIcon:UIImageView!
    @IBOutlet var PasstyID:UILabel!
    @IBOutlet var Result:UILabel!
    var proximityArray = [String](repeating: "Unknown", count: 15)
    var proximityJPLabels: [String: String] = ["Unknown": "近くに見つかりません", "Far": "30m以内", "Near": "10m以内", "Immediate": "1m以内"]

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    func updateProximityArray(proximity: String){
        proximityArray.append(proximity)
        proximityArray.removeFirst()
        print("\(proximityArray)")
        var proximityIsUnknown = true;
        for _proximity in proximityArray {
            if ( _proximity != "Unknown" ) {
                proximityIsUnknown = false;
                break
            }
        }
        if ( proximityIsUnknown == true ) {
            Result.text = proximityJPLabels["Unknown"];
        } else {
            let last_proximity = proximityArray.filter{ $0 != "Unknown" }.last!;
            Result.text = proximityJPLabels[last_proximity];
        }
    }
    
    func resetProximity() {
        proximityArray = [String](repeating: "Unknown", count: 15)
    }

}

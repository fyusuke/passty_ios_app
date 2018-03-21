//
//  SideMenuViewController.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/27.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)

        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name("ShowFetchNewInfoPage"), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowContactUsPage"), object: nil)
        case 2: NotificationCenter.default.post(name: NSNotification.Name("ShowTermOfService"), object: nil)
        case 3: NotificationCenter.default.post(name: NSNotification.Name("SignOut"), object: nil)
        default: break
        }
    }
}

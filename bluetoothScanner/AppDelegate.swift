//
//  AppDelegate.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/02/21.
//  Copyright © 2018年 yusuke. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter
import AudioToolbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests();
        let content = UNMutableNotificationContent()
        content.title = "Passtyアプリがオフになりました";
        content.subtitle = "iOS Development is fun"
        content.body = "紛失アラート機能を利用する場合は、アプリを立ち上げたままにしてください";
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest.init(identifier: "CloseScreenAlertNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
        center.delegate = self

        print("terminated")
    }
    
    //上記のNotificatio後に受け取る関数
    //ポップアップ表示のタイミングで呼ばれる関数
    //（アプリがアクティブ、非アクテイブ、アプリ未起動,バックグラウンドでも呼ばれる）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("terminated2")
        completionHandler([.alert,.sound])
    }
    
//    //ポップアップ押した後に呼ばれる関数(↑の関数が呼ばれた後に呼ばれる)
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        //Alertダイアログでテスト表示
//        let contentBody = response.notification.request.content.body
//        let alert:UIAlertController = UIAlertController(title: "受け取りました", message: contentBody, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//            (action:UIAlertAction!) -> Void in
//            print("Alert押されました")
//        }))
//        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//
//        completionHandler()
//    }

}


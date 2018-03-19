import UIKit
import SlideMenuControllerSwift
import CoreLocation
import UserNotifications
import NotificationCenter

class PasstyListViewController: SlideMenuController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    var myBeaconRegion:CLBeaconRegion!
    var myLocationManager:CLLocationManager!
    var proximityJPLabels: [String: String] = ["Unknown": "近くに見つかりません", "Far": "30m以内", "Near": "10m以内", "Immediate": "1m以内"]
    let stock_info: [[String: String]] = UserDefaults.standard.object(forKey: "stock_info") as! [[String: String]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = UserDefaults.standard.string(forKey: "access_token") else {
            NotificationCenter.default.post(name: NSNotification.Name("SignOut"), object: nil)
            return
        }
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 1
        let status = CLLocationManager.authorizationStatus()
        print("CLAuthorizedStatus: \(status.rawValue)");
        if(status == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
            //            myLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    // セルが表示されるときに呼ばれる処理（1個のセルを描画する毎に呼び出されます
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath as IndexPath) as! CustomCell
        let ibeacon = stock_info[indexPath.row]
        cell.tag = Int(ibeacon["major"]!)! * 1000 + Int(ibeacon["minor"]!)!
        cell.PasstyID.text = "ID: \(ibeacon["serial_num"]!)"
        return cell
    }
    
    // セクションの数（今回は1つだけです）
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stock_info.count
    }
    
    private func startMyMonitoring() {
        for i in 0 ..< stock_info.count {
            let beacon = stock_info[i]
            print("uuid:\(beacon["uuid"]!)")
            print("major:\(beacon["major"]!)")
            print("minor:\(beacon["minor"]!)")
            print("serial_num:\(beacon["serial_num"]!)")
            let uuid: NSUUID! = NSUUID(uuidString: "\(beacon["uuid"]!.lowercased())")
            let major = Int(beacon["major"]!)
            let minor = Int(beacon["minor"]!)
            let identifierStr: String = "iBeacon_\(beacon["uuid"]!)_\(beacon["major"]!)_\(beacon["minor"]!)"
            myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, major: CLBeaconMajorValue(major!), minor: CLBeaconMinorValue(minor!), identifier: identifierStr)
            myBeaconRegion.notifyEntryStateOnDisplay = false
            myBeaconRegion.notifyOnEntry = true
            myBeaconRegion.notifyOnExit = true
            myLocationManager.startMonitoring(for: myBeaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus");
        print("\(status)")
        switch (status) {
        case .notDetermined:
            print("not determined")
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .authorizedAlways:
            print("authorizedAlways")
            startMyMonitoring()
            break
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            startMyMonitoring()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region);
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch (state) {
        case .inside:
            print("iBeacon inside");
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
        case .outside:
            print("iBeacon outside")
            break;
        case .unknown:
            print("iBeacon unknown")
            break;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if(beacons.count > 0){
            for i in 0 ..< beacons.count {
                let beacon = beacons[i];
                print("beacons: \(beacons)")
                print("beacon.proximityUUID: \(beacon.proximityUUID)")
                print("beacon.major: \(beacon.major)")
                print("beacon.minor: \(beacon.minor)")
                var proximity = ""
                switch (beacon.proximity) {
                case CLProximity.unknown :
                    proximity = "Unknown"
                    break
                case CLProximity.far:
                    proximity = "Far"
                    break
                case CLProximity.near:
                    proximity = "Near"
                    break
                case CLProximity.immediate:
                    proximity = "Immediate"
                    break
                }
                
                if let customCell: CustomCell = self.view.viewWithTag(beacon.major.intValue * 1000 + beacon.minor.intValue) as? CustomCell{
                    customCell.updateProximityArray(proximity: proximity)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: iBeacon found");
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: iBeacon lost");
        let beacon = region as! CLBeaconRegion
        if beacon.major != nil && beacon.minor != nil {
            if let customCell: CustomCell = self.view.viewWithTag(beacon.major!.intValue * 1000 + beacon.minor!.intValue) as? CustomCell{
                customCell.resetProximity()
                customCell.Result.text = "近くに見つかりません"
                
                let content = UNMutableNotificationContent()
                content.title = "ID：\(customCell.PasstyID.text as Optional)は手元にありますか？"
                content.body = "Passtyを見失いました"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
                let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        manager.stopRangingBeacons(in: beacon)
    }
}

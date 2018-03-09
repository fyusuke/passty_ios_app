//
//  CustomCell.swift
//  bluetoothScanner
//
//  Created by 福原佑介 on 2018/03/08.
//  Copyright © 2018年 yusuke. All rights reserved.
//


import UIKit
import CoreLocation

class CustomCell: UICollectionViewCell, CLLocationManagerDelegate {
    @IBOutlet var PassportIcon:UIImageView!
    @IBOutlet var PasstyID:UILabel!
    @IBOutlet var Result:UILabel!
    var proximityArray = [String](repeating: "Unknown", count: 15) //mutable
    var proximityJPLabels: [String: String] = ["Unknown": "近くに見つかりません", "Far": "30m以内", "Near": "10m以内", "Immediate": "1m以内"]
    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var UUID: String!
    var major: String!
    var minor: String!
    var serial_num: String!
    var beaconUuid: String!
    var beaconDetail: String!

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .red
        print("start custom cell")
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
    
    private func startMyMonitoring() {
        print("uuid:\(UUID)")
        print("major:\(major)")
        print("minor:\(minor)")
        print("minor:\(serial_num)")
        let uuid: NSUUID! = NSUUID(uuidString: "\(UUID.lowercased())")
        let identifierStr: String = "iBeacon"
        myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: identifierStr)
        myBeaconRegion.notifyEntryStateOnDisplay = false
        myBeaconRegion.notifyOnEntry = true
        myBeaconRegion.notifyOnExit = true
        myLocationManager.startMonitoring(for: myBeaconRegion)
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
        beaconUuid = String()
        beaconDetail = String()
        if(beacons.count > 0){
            let beacon = beacons[0];
            let beaconUUID = beacon.proximityUUID;
            let minorID = beacon.minor;
            let majorID = beacon.major;
            let rssi = beacon.rssi;
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
            print("Proximity: \(proximityJPLabels[proximity] ?? "")");
            proximityArray.append(proximity)
            proximityArray.removeFirst()
            
            beaconUuid = beaconUUID.uuidString
            var myBeaconDetail = "Major: \(majorID) "
            myBeaconDetail += "Minor: \(minorID) "
            myBeaconDetail += "Proximity:\(proximity) "
            myBeaconDetail += "RSSI:\(rssi)"
            //            print(myBeaconDetail)
            print(proximityArray)
            beaconDetail = myBeaconDetail
            
            var proximityIsUnknown = true;
            for proximity in proximityArray {
                if ( proximity != "Unknown" ) {
                    proximityIsUnknown = false;
                    break
                }
            }
            
            PasstyID.text = "ID: \(serial_num) "
            if ( proximityIsUnknown == true ) {
                Result.text = proximityJPLabels["Unknown"];
            } else {
                let last_proximity = proximityArray.filter{ $0 != "Unknown" }.last!;
                Result.text = proximityJPLabels[last_proximity];
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: iBeacon found");
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: iBeacon lost");
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
}

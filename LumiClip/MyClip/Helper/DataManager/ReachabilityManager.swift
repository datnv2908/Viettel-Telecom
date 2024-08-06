//
//  ReachabilityManager.swift
//  MyClip
//
//  Created by hnc on 12/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import ReachabilitySwift

/// Protocol for listenig network status change
public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    let reachability = Reachability()!
    var listeners = [NetworkStatusListener]()

    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
            Singleton.sharedInstance.isConnectedInternet = false
            NotificationCenter.default.post(name: .kLoseInternet, object: nil, userInfo: nil)
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
            Singleton.sharedInstance.isConnectedInternet = true
            NotificationCenter.default.post(name: .kConnectInternet, object: nil, userInfo: nil)
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
            Singleton.sharedInstance.isConnectedInternet = true
            NotificationCenter.default.post(name: .kConnectInternet, object: nil, userInfo: nil)
        }
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }

    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }

    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }

    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }

    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
}

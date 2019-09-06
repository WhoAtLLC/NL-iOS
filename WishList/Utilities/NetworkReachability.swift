//
//  NetworkReachability.swift
//  NetworkReachability
//
//  Created by lsd on 14/09/16.
//  Copyright © 2016 Dabus.tv. All rights reserved.
//  Swift 2.3

import UIKit
import SystemConfiguration

struct Notification {
    static let flagsChanged = "FlagsChangedNotification"
}

class NetworkReachability {
    var hostname: String?
    var isRunning: Bool = false
    var reachableOnWWAN: Bool = false
    var networkReachability: SCNetworkReachability?
    var networkReachabilityFlags = SCNetworkReachabilityFlags()
    let reachabilitySerialQueue = DispatchQueue(label: "reachabilitySerialQueue", attributes: [])
    required init(networkReachability: SCNetworkReachability) {
        reachableOnWWAN = true
        self.networkReachability = networkReachability
    }
    convenience init?(hostname: String) throws {
        guard let networkReachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw ReachabilityError.failedToCreateWith(hostname)
        }
        self.init(networkReachability: networkReachability)
        self.hostname = hostname
    }
    convenience init?() throws {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
       let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        self.init(networkReachability: defaultRouteReachability!)
    }
    var networkStatus: NetworkStatus {
        if !isConnectedToNetwork { return .unreachable }
        if isReachableViaWiFi    { return .wifi }
        return isRunningOnDevice ? .wwan : .unreachable
    }
    var isRunningOnDevice: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }()
    deinit { stop() }
}

extension NetworkReachability {
    func start() throws {
        guard let networkReachability = networkReachability, !isRunning else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())       //UnsafeMutablePointer(Unmanaged.passUnretained(self).toOpaque())
        guard SCNetworkReachabilitySetCallback(networkReachability, callout as? SCNetworkReachabilityCallBack, &context) else {
            stop()
            throw ReachabilityError.failedToSetCallout
        }
        guard SCNetworkReachabilitySetDispatchQueue(networkReachability, reachabilitySerialQueue) else {
            stop()
            throw ReachabilityError.failedToSetDispatchQueue
        }
        reachabilitySerialQueue.async { self.flagsChanged() }
        isRunning = true
    }
    func stop() {
        defer { isRunning = false }
        guard let networkReachability = networkReachability else { return }
        SCNetworkReachabilitySetCallback(networkReachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(networkReachability, nil)
        self.networkReachability = nil
    }
    var isConnectedToNetwork: Bool {
        guard isReachable else { return false }
        guard !isConnectionRequiredAndTransientConnection else { return false }
        if isRunningOnDevice { if isWWAN && !isReachableOnWWAN { return false } }
        return true
    }
    var isReachableViaWiFi: Bool {
        guard isReachable else { return false }
        guard isRunningOnDevice  else { return true  }
        return !isWWAN
    }
    var flags: SCNetworkReachabilityFlags? {
        guard let networkReachability = networkReachability else { return nil }
        var flags = SCNetworkReachabilityFlags()
        return withUnsafeMutablePointer(to: &flags) { SCNetworkReachabilityGetFlags(networkReachability, UnsafeMutablePointer($0)) } ? flags : nil
    }
    func flagsChanged() {
        guard let flags = flags, networkReachabilityFlags != flags else { return }
        networkReachabilityFlags = flags
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.flagsChanged), object: self)
    }
    
    var isReachable: Bool { return reachable }
    var isConnectionRequiredAndTransientConnection: Bool { return connectionRequiredAndTransientConnection }
    var isReachableOnWWAN: Bool { return reachableOnWWAN }
    
    var transientConnection: Bool {
        return flags?.contains(.transientConnection) == true
    }
    
    var reachable: Bool {
        return flags?.contains(.reachable) == true
    }
    
    var connectionRequired: Bool {
        return flags?.contains(.connectionRequired) == true
    }
    
    var connectionOnTraffic: Bool {
        return flags?.contains(.connectionOnTraffic) == true
    }
    
    var interventionRequired: Bool {
        return flags?.contains(.interventionRequired) == true
    }
    
    var connectionOnDemand: Bool {
        return flags?.contains(.connectionOnDemand) == true
    }
    
    var isLocalAddress: Bool {
        return flags?.contains(.isLocalAddress) == true
    }
    
    var isDirect: Bool {
        return flags?.contains(.isDirect) == true
    }
    
    var isWWAN: Bool {
        return flags?.contains(.isWWAN) == true
    }
    
    var connectionRequiredAndTransientConnection: Bool {
        return flags?.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
}

func callout(_ reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer) {
    //DispatchQueue.main.async { Unmanaged<NetworkReachability>.fromOpaque(OpaquePointer(info).takeUnretainedValue().flagsChanged() }
    DispatchQueue.main.async {
        Unmanaged<NetworkReachability>.fromOpaque(info).takeUnretainedValue()
    }
}

enum ReachabilityError: Error {
    case failedToSetCallout
    case failedToSetDispatchQueue
    case failedToCreateWith(String)
    case failedToInitializeWith(sockaddr_in)
}

enum NetworkStatus: String {
    case unreachable, wifi, wwan
}

extension NetworkStatus: CustomStringConvertible {
    var description: String { return rawValue }
}

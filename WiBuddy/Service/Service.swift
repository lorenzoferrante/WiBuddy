//
//  Service.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 11/26/20.
//

import Foundation
import CoreWLAN
import SwiftUI

class Service: NSObject, CWEventDelegate, ObservableObject {
    
    static let shared = Service()
    
    @Published public var channelList: [Int] = []
    @Published public var status: ServiceStatus?
    @Published public var connectedSSID: String?
    @Published public var isScanning: Bool = true {
        didSet {
            if (isScanning) {
                status = .scanning
            } else {
                status = .stopped
            }
        }
    }
    
    private var nets: [Network]?
    private var interface: CWInterface? {
        return client.interface()
    }
    private let client: CWWiFiClient = CWWiFiClient.shared()
    
    private override init() {
        super.init()
        client.delegate = self
        startScanning()
        connectedSSID = client.interface()?.ssid()
    }
    
    public func scan() -> [Network]? {
        channelList = []
        var nets: [Network] = []
        if let en0 = interface {
            do {
                let netowrks = try en0.scanForNetworks(withName: nil)
                for net in netowrks {
                    if let wlanChannel = net.wlanChannel {
                        nets.append(Network(ssid: net.ssid,
                                            channelNumber: wlanChannel.channelNumber,
                                            channelBand: convertToChannelBand(wlanChannel.channelBand),
                                            channelWidth: convertToChannelWidth(wlanChannel.channelWidth)))
                        if (!channelList.contains(wlanChannel.channelNumber)) {
                            channelList.append(wlanChannel.channelNumber)
                        }
                    }
                }
                self.nets = nets
                return nets
            } catch let error {
                print("[ERROR] \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    public func startScanning() {
        do {
            try client.startMonitoringEvent(with: .ssidDidChange)
            isScanning = true
            print("[DEBUG] Started scanning...")
        } catch let error {
            print("[ERROR] \(error.localizedDescription)")
        }
    }
    
    public func stopScanning() {
        if isScanning {
            do {
                try client.stopMonitoringAllEvents()
                isScanning = false
                print("[DEBUG] Stopped scanning...")
            } catch let error {
                print("[ERROR] \(error.localizedDescription)")
            }
        }
    }
    
}

/* MARK: CWEventDelegate */
extension Service {
    
    func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        DispatchQueue.main.async {
            self.connectedSSID = self.client.interface(withName: interfaceName)?.ssid()
        }
        print("[DEBUG] Connected to: \(connectedSSID ?? "no-name")")
    }
    
}

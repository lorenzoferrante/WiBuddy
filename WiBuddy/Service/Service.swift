//
//  Service.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 11/26/20.
//

import Foundation
import CoreWLAN
import SwiftUI

class Service: NSObject, CWEventDelegate, ObservableObject, CLLocationManagerDelegate {
    
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
    
    @Published public var networkSNR: NetworkSNR = NetworkSNR(rssi: 0, noise: 0)
    
    @Published public var nets: [Network] = []
    
    private var interface: CWInterface? {
        return client.interface()
    }
    private let client: CWWiFiClient = CWWiFiClient.shared()
    
    var timer: Timer!
    
    private override init() {
        super.init()
        client.delegate = self
        startScanLocationManager()
        connectedSSID = client.interface()?.ssid()
    }
    
    private func startScanLocationManager() {
        let locationManager: CLLocationManager = CLLocationManager()
        if #available(macOS 10.15, *) {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
                self.scan()
            })
        }
    }
    
    public func scan() {
        self.startScanning()
        
        self.nets = []
        channelList = []
        if let en0 = interface {
            do {
                let netowrks = try en0.scanForNetworks(withName: nil)
                for net in netowrks {
                    if let wlanChannel = net.wlanChannel {
                        nets.append(Network(
                                        bssid: net.bssid,
                                        ssid: net.ssid,
                                        rssi: net.rssiValue,
                                        channelNumber: wlanChannel.channelNumber,
                                        channelBand: convertToChannelBand(wlanChannel.channelBand),
                                        channelWidth: convertToChannelWidth(wlanChannel.channelWidth)))
                        if (!self.channelList.contains(wlanChannel.channelNumber)) {
                            self.channelList.append(wlanChannel.channelNumber)
                        }
                    }
                }
            } catch let error {
                print("[ERROR] \(error.localizedDescription)")
                self.stopScanning()
            }
            self.stopScanning()
        }
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
    
    public func scanFor(networkName: String, band: ChannelBand) {
        if let en0 = interface {
            do {
                let netowrks = try en0.scanForNetworks(withName: networkName)
                for net in netowrks {
                    if (convertToChannelBand(net.wlanChannel?.channelBand) == band) {
                        self.networkSNR.rssi = net.rssiValue
                        self.networkSNR.noise = net.noiseMeasurement
                    }
                }
            } catch let error {
                print("[ERROR] \(error.localizedDescription)")
            }
        }
    }
    
}

/* MARK: CWEventDelegate */
extension Service {
    
    func bssidDidChangeForWiFiInterface(withName interfaceName: String) {
        DispatchQueue.main.async {
            self.connectedSSID = self.client.interface(withName: interfaceName)?.bssid()
        }
    }
    
    func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        DispatchQueue.main.async {
            self.connectedSSID = self.client.interface(withName: interfaceName)?.ssid()
        }
        print("[DEBUG] Connected to: \(connectedSSID ?? "no-name")")
    }
    
}

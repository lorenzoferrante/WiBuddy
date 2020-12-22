//
//  Network.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 11/26/20.
//

import Foundation
import CoreWLAN

public struct NetworkSNR {
    var rssi: Int
    var noise: Int
}

public enum ServiceStatus: String {
    case scanning = "Scanning"
    case stopped = "Stopped"
}

public enum ChannelBand: CustomStringConvertible {
    case band2GHz
    case band5GHz
    case bandUnknown
    
    public var description: String {
        switch self {
        case .band2GHz: return "2GHz"
        case .band5GHz: return "5GHz"
        case .bandUnknown: return "Unknown"
        }
    }
}

public enum ChannelWidth: CustomStringConvertible {
    case width160MHz
    case width20MHz
    case width40MHz
    case width80MHz
    case widthUnknown
    
    public var description: String {
        switch self {
        case .width160MHz: return "160MHz"
        case .width20MHz: return "20MHz"
        case .width40MHz: return "40MHz"
        case .width80MHz: return "80MHz"
        case .widthUnknown: return "Unknown"
        }
    }
}

private func calculateQualityPercentage(rssi: Int) -> Int {
    if (rssi <= -110) {
        return 0
    } else if (rssi >= -40){
        return 100
    } else {
        return rssi + 110
    }
}

public struct Network: Hashable {
    var bssid: String?
    var ssid: String?
    var rssi: Int?
    var quality: Int? {
        return min(calculateQualityPercentage(rssi: rssi!), 100)
    }
    var noise: Int? 
    var channelNumber: Int?
    var channelBand: ChannelBand?
    var channelWidth: ChannelWidth?
}

public func convertToChannelBand(_ cwCB: CWChannelBand?) -> ChannelBand {
    if let cw = cwCB {
        switch cw {
        case .band2GHz: return ChannelBand.band2GHz
        case .band5GHz: return ChannelBand.band5GHz
        case .bandUnknown: return ChannelBand.bandUnknown
        @unknown default:
            fatalError("Error")
        }
    }
    return ChannelBand.bandUnknown
}

public func convertToChannelWidth(_ cwCB: CWChannelWidth?) -> ChannelWidth {
    if let cw = cwCB {
        switch cw {
        case .width160MHz: return .width160MHz
        case .width20MHz: return .width20MHz
        case .width40MHz: return .width40MHz
        case .width80MHz: return .width80MHz
        case .widthUnknown: return .widthUnknown
        @unknown default:
            fatalError("Error")
        }
    }
    return .widthUnknown
}

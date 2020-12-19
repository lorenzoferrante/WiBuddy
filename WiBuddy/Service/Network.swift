//
//  Network.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 11/26/20.
//

import Foundation
import CoreWLAN

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

public struct Network: Hashable {
    var bssid: String?
    var ssid: String?
    var rssi: Int?
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

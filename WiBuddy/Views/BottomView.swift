//
//  BottomView.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 21/12/20.
//

import SwiftUI

struct BottomView: View {
    
    @State var network: Network?
    @ObservedObject var service = Service.shared
    
    var timer = Timer.publish(every: 1, on: .main, in: .common)
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                Text("RSSI: \(service.networkSNR.rssi) - NOISE: \(service.networkSNR.noise)")
            }
            .onReceive(timer, perform: { (_) in
                if let net = network {
                    service.scanFor(networkName: net.ssid!, band: net.channelBand!)
                }
            })
            .frame(height: (geometry.size.height / 2))
        }
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView()
    }
}

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
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(alignment: .leading) {
                Text("\(service.selectedNetork?.ssid ?? "unknown")")
                    .font(Font.system(size: 15.0, weight: .bold, design: .monospaced))
                Text("RSSI: \((service.selectedSNR.rssi) ?? -1) - NOISE: \((service.selectedSNR.noise) ?? -1)")
                    .font(Font.system(size: 13.0, weight: .semibold, design: .monospaced))
            }
            .onReceive(timer, perform: { (_) in
                print("timer updated")
                if let net = network {
                    service.selectedNetork = net
                }
            })
            .frame(height: (geometry.size.height / 2))
            .padding()
        }
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView()
    }
}

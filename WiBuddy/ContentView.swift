//
//  ContentView.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 11/25/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var searchText: String = ""
    @State private var isAnimating: Bool = false
    @ObservedObject var service = Service.shared
    
    var bands = ["2 GHz", "5 GHz"]
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    @State var networks: [Network] = Service.shared.scan() ?? []
    
    
    var body: some View {
        
        NavigationView {
            wifiList(networks)
                .onReceive(timer) { (_) in
                    if let nets = self.service.scan() {
                        networks = nets
                    }
                }
        }
        .navigationTitle("")
        
    }
    
    func wifiList(_ networks: [Network]) -> some View {
        let band2Ghz = networks.filter { $0.channelBand! == .band2GHz }
        let band5Ghz = networks.filter { $0.channelBand! == .band5GHz }
        
        var body: some View {
            List {
                Section(header:
                            HStack {
                                Text("WiFi List")
                                Spacer()
                                Text("\(networks.count)")
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                ) {
                    ForEach(networks, id: \.self) { net in
                        if (service.connectedSSID == net.ssid) {
                            HStack {
                                Image(systemName: "wifi").imageScale(.small).foregroundColor(.green)
                                Text(net.ssid!).bold()
                            }
                            .padding(0)
                        } else {
                            HStack {
                                Image(systemName: "wifi").imageScale(.small)
                                Text(net.ssid!)
                            }
                        }
                    }
                }
                
                Section(header: Text("Band")) {
                    ForEach(bands, id: \.self) { band in
                        HStack {
                            Image(systemName: "arrow.left.arrow.right").imageScale(.small)
                            Text(band)
                            Spacer()
                            Text((band == bands[0] ? "\(band2Ghz.count)" : "\(band5Ghz.count)"))
                                .statusFontDesign()
                                .opacity(0.5)
                        }
                    }
                }
                
                Section(header: Text("Channel")) {
                    ForEach(service.channelList.sorted(), id: \.self) { ch in
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right").imageScale(.small)
                            Text("Channel \(ch)")
                            Spacer()
                            Text("\(networks.filter { $0.channelNumber ==  ch }.count)")
                                .statusFontDesign()
                                .opacity(0.5)
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .listRowInsets(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button(action: {
                        toggleSidebar()
                    }, label: {
                        Image(systemName: "sidebar.leading")
                            .foregroundColor(.primary)
                            .imageScale(.medium)
                    })
                }
                
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        service.startScanning()
                    }, label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.primary).opacity((service.isScanning ? 0.2 : 1.0))
                            .imageScale(.medium)
                    })
                    .disabled(service.isScanning)
                }
                
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        service.stopScanning()
                    }, label: {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.primary).opacity((!service.isScanning ? 0.2 : 1.0))
                            .imageScale(.medium)
                    })
                    .disabled(!service.isScanning)
                }
                
                ToolbarItem(placement: .navigation) {
                    makeTitle()
                        .padding(0)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(5.0)
                        .frame(alignment: .center)
                }
                
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        toggleSidebar()
                    }, label: {
                        Image(systemName: "sidebar.trailing")
                            .foregroundColor(.primary)
                            .imageScale(.medium)
                    })
                }
            }
        }
        return body
    }
    
    func makeTitle() -> some View {
        var body: some View {
            VStack(alignment: HorizontalAlignment.center) {
                HStack(alignment: VerticalAlignment.center) {
                    Spacer()
                    ProgressView()
                        .scaleEffect(0.5)
                        .progressViewStyle(CircularProgressViewStyle())
                        .rotationEffect(.degrees(360))
                        .animation(.linear(duration: 1.5))
                        .accessibility(hidden: (service.isScanning ? true : false))
                        .onAppear(perform: {
                            self.isAnimating = true
                        })
                    Text("Status: \(service.status?.rawValue ?? "Unknown")")
                        .statusFontDesign()
                    Text(" | ")
                        .statusFontDesign()
                    if let ssid = service.connectedSSID {
                        HStack {
                            Text("Connected to: ").statusFontDesign()
                            Text("\(ssid)").bold().statusFontDesign().foregroundColor(.green)
                        }
                    } else {
                        Text("Not Connected").bold().statusFontDesign().foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding(0)
            }
        }
        return body
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

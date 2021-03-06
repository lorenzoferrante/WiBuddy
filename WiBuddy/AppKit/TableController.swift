//
//  TableController.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 17/12/20.
//

import Cocoa
import SwiftUI

class TableController: NSViewController, NSTableViewDataSource, NetworksUpdate, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var doubleTappedRow: Int = 0
    var networkDelegate: NetworksUpdate?
    
    var networks: Array<Network> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.style = .fullWidth
        tableView.rowSizeStyle = .medium
        
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDidClick(_:))
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.networks.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let network = self.networks[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "bssidColumn") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "bssidCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = network.bssid ?? "Unknown"
            return cellView
            
        }
        
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "ssidColumn") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ssidCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = network.ssid ?? "Unknown"
            return cellView
            
        }
        
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "channelColumn") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "channelCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = "\(network.channelNumber ?? -1)"
            return cellView
            
        }
        
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "bandColumn") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "bandCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = network.channelBand?.description ?? "error"
            return cellView
            
        }
        
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "widthColumn") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "widthCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = network.channelWidth?.description ?? "error"
            return cellView
            
        }
        
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "rssiColumn") {
            
            //let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "rssiCell")
            let signalView = NSHostingView(rootView: SignalView(dbm: network.rssi!,
                                                                percentage: network.quality!,
                                                                height: 13.0,
                                                                radius: 5.0,
                                                                ratio: 0.25))
            return signalView
            
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NSTableRowView()
        rowView.isEmphasized = false
        return rowView
    }

    
    func networkListDidUpdate(networks: [Network]) {
        self.networks = networks
        self.tableView.reloadData()
    }
    
    @objc func tableViewDidClick(_ tableView: NSTableView) {
        if (tableView.clickedRow != doubleTappedRow) {
            Service.shared.selectedNetork = self.networks[tableView.clickedRow]
            doubleTappedRow = tableView.clickedRow
        }
    }
    
}

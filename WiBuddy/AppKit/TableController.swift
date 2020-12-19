//
//  TableController.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 17/12/20.
//

import Cocoa

class TableController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NetworksUpdate {
    
    @IBOutlet var tableView: NSTableView!
    
    var networkDelegate: NetworksUpdate?
    
    var networks: Array<Network> = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.style = .fullWidth
        tableView.rowSizeStyle = .medium
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
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "rssiCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = "\(network.rssi ?? -1) dBm"
            return cellView
            
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
    
}

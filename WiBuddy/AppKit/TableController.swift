//
//  TableController.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 17/12/20.
//

import Cocoa
import SwiftUI

protocol NSTableViewClickableDelegate: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, didClickRow row: Int, didClickColumn: Int)
}

class NSClickableTableView: NSTableView {
    weak open var clickableDelegate: NSTableViewClickableDelegate?
}

class TableController: NSViewController, NSTableViewDataSource, NetworksUpdate, NSTableViewClickableDelegate, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSClickableTableView!
    
    var networkDelegate: NetworksUpdate?
    
    var networks: Array<Network> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.clickableDelegate = self
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
    
    func tableView(_ tableView: NSTableView, didClickRow row: Int, didClickColumn: Int) {
        print("Row: \(row) - Col: \(didClickColumn)")
    }
    
}

extension NSTableView {
    
    open override func mouseDown(with event: NSEvent) {
        let localLocation = self.convert(event.locationInWindow, to: nil)
        let clickedRow = self.row(at: localLocation)
        let clickedColumn = self.column(at: localLocation)

        super.mouseDown(with: event)

        guard clickedRow >= 0, clickedColumn >= 0, let delegate = self.delegate as? NSTableViewClickableDelegate else {
            return
        }

        delegate.tableView(self, didClickRow: clickedRow, didClickColumn: clickedColumn)
    }
    
}


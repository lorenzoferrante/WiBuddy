//
//  WiFiTableView.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 17/12/20.
//

import Foundation
import Cocoa
import SwiftUI

public protocol NetworksUpdate {
    func networkListDidUpdate(networks: [Network])
}

struct WiFiTable: NSViewControllerRepresentable {
    
    @Binding var networks: Array<Network>
    
    typealias NSViewControllerType = TableController
    
    func makeNSViewController(context: Context) -> TableController {
        let tableController = TableController(nibName: NSNib.Name("TableController"), bundle: nil)
        tableController.networkDelegate?.networkListDidUpdate(networks: self.networks)
        return tableController
    }
    
    func updateNSViewController(_ nsViewController: TableController, context: Context) {
        nsViewController.networkDelegate?.networkListDidUpdate(networks: self.networks)
        nsViewController.tableView.reloadData()
    }
    
}

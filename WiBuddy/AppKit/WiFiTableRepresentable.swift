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
    
    @ObservedObject var service = Service.shared
    
    typealias NSViewControllerType = TableController
    
    func makeNSViewController(context: Context) -> TableController {
        let tableController = TableController(nibName: NSNib.Name("TableController"), bundle: nil)
        let nets = service.nets.sorted(by: { $0.quality! > $1.quality! })
        tableController.networkDelegate?.networkListDidUpdate(networks: nets)
        return tableController
    }
    
    func updateNSViewController(_ nsViewController: TableController, context: Context) {
        let nets = service.nets.sorted(by: { $0.quality! > $1.quality! })
        nsViewController.networkDelegate?.networkListDidUpdate(networks: nets)
        nsViewController.tableView.reloadData()
    }
    
}

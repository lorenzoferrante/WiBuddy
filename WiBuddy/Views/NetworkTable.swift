//
//  NetworkTable.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 17/12/20.
//

import SwiftUI

struct NetworkTable: View {
    
    @Binding var networks: Array<Network>
    
    var body: some View {
        WiFiTable(networks: $networks)
            .frame(alignment: .topLeading)
    }
}

struct NetworkTable_Previews: PreviewProvider {
    static var previews: some View {
        NetworkTable(networks: .constant([]))
    }
}

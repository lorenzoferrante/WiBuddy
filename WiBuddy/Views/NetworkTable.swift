//
//  NetworkTable.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 17/12/20.
//

import SwiftUI

struct NetworkTable: View {
    
    @ObservedObject var service = Service.shared
    
    var body: some View {
        WiFiTable()
            .frame(alignment: .topLeading)
    }
}

struct NetworkTable_Previews: PreviewProvider {
    static var previews: some View {
        NetworkTable()
    }
}

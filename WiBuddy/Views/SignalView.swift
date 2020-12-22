//
//  SignalView.swift
//  WiBuddy
//
//  Created by Lorenzo Ferrante on 19/12/20.
//

import SwiftUI

struct PercentageView: View {
    @State var percentage: Int = 65
    @State var parentWidth: CGFloat = 200.0
    @State var parentHeight: CGFloat = 50.0
    
    var isSelected: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(calculateColor())
            .frame(width: (parentWidth * CGFloat(percentage) / 100), height: parentHeight - 2)
    }
    
    private func calculateColor() -> Color {
        if (percentage <= 20) {
            return Color.gray
        } else if (percentage > 20 && percentage <= 49) {
            return Color.red
        } else if (percentage >= 50 && percentage < 70) {
            return Color.orange
        } else {
            return Color.green
        }
    }
}

struct SignalView: View {
    @State var dbm: Int = -1
    @State var percentage: Int = 72
    @State var height: CGFloat = 13.0
    @State var radius: CGFloat = 2.0
    
    var ratio: CGFloat = 0.25
    
    var body: some View {
        HStack {
            Text("\(percentage)% (\(dbm)dBm)")
                .font(Font.system(size: 13.0))
                .foregroundColor(Color.primary)
            
            ZStack(alignment: .leading) {
                PercentageView(percentage: percentage, parentWidth: (height / ratio), parentHeight: height)
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(Color.white.opacity(0.0))
                    .frame(width: (height / ratio), height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
            }
        }
    }
}


struct SignalView_Previews: PreviewProvider {
    static var previews: some View {
        SignalView(dbm: -1, percentage: 65, height: 50, radius: 5)
    }
}

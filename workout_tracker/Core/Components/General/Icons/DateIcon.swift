//
//  DateIconView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/2/22.
//

import SwiftUI

struct DateIcon: View {
    let date: Date
    let bordered: Bool
    
    init(date: Date, bordered: Bool = false) {
        self.date = date
        self.bordered = bordered
    }
    
    var body: some View {
        GeometryReader { geometry -> AnyView? in
            let iconHeight = geometry.size.height
            
            return AnyView(
                VStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.init(red: 222/255, green: 10/255, blue: 67/255))
                            .frame(height: iconHeight / 3)
                        
                        Text(CustomDateFormatter.abbrMonth.string(from: date))
                            .foregroundColor(.white)
                            .font(.system(size: iconHeight * 0.275))
                    }
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                        
                        Text(CustomDateFormatter.dateDay.string(from: date))
                            .foregroundColor(.black)
                            .font(.system(size: iconHeight * 0.55, weight: .bold, design: .serif))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: iconHeight / 6))
                .overlay(
                    RoundedRectangle(cornerRadius: iconHeight / 6)
                        .stroke(.black, lineWidth: bordered ? 2 : 0)
                        )
                
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct DateIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemGray5)
            DateIcon(date: Date.now)
                .frame(width: 150)
        }
    }
}

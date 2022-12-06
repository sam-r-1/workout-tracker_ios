//
//  DateIconView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/2/22.
//

import SwiftUI

struct DateIcon: View {
    let date: Date
    let color = Color.primary
    

    
    var body: some View {
        GeometryReader { geometry -> AnyView? in
            let height = geometry.size.height
            
            return AnyView(
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.init(red: 222/255, green: 10/255, blue: 67/255))
                            .frame(height: height / 4)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(.systemGray4))
                            
                            VStack(spacing: 0) {
                                Text(
                                    CustomDateFormatter.abbrMonth.string(from: date)
                                     + " "
                                     + CustomDateFormatter.dateDay.string(from: date)
                                )
                                    .font(.system(size: height * 0.28))
                                
                                Text(CustomDateFormatter.year.string(from: date))
                                    .font(.system(size: height * 0.23))
                            }
                        }
                    }
                        .clipShape(RoundedRectangle(cornerRadius: height / 6))
                    
                    HStack(spacing: height * 0.35) {
                        Group {
                            Capsule()
                            Capsule()
                        }
                        .frame(width: height * 0.1)
                    }
                    .frame(height: height * 0.2)
                    .offset(y: -height * 0.08)
                }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct DateIconView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DateIcon(date: Date.now)
                .frame(width: 150)
            
            ZStack {
                Color(.systemGray6)
                DateIcon(date: Date.now)
                    .frame(width: 150)
                    .preferredColorScheme(.dark)
            }
        }
    }
}

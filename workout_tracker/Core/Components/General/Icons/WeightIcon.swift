//
//  WeightIcon.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/5/22.
//

import SwiftUI
import TrapezoidShapes

struct WeightIcon: View {
    var body: some View {
        GeometryReader { geometry -> AnyView? in
            let height = geometry.size.height
            
            return AnyView(
                VStack(spacing: -height * 0.04) {
                    Circle()
                        .stroke(lineWidth: height * 0.1)
                        .frame(height: height / 3.5)
                        
                    RoundedTrapezoid(cornerRadius: height * 0.1, edgeRatio: 0.8, flexibleEdge: .top, edgeOffset: 0.0)
                }
            )
        }
        .aspectRatio(1.1, contentMode: .fit)
    }
}

struct WeightIcon_Previews: PreviewProvider {
    static var previews: some View {
        WeightIcon()
            .frame(width: 200)
    }
}

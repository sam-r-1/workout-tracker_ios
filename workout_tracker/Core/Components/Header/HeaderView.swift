//
//  HeaderView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct HeaderView: View {
    let headerText: String
    let includeDivider: Bool
    
    init(_ headerText: String, includeDivider: Bool = false) {
        self.headerText = headerText
        self.includeDivider = includeDivider
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(headerText)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            
            if includeDivider { Divider() }
        }
        .padding([.top, .horizontal])
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView("My Workouts")
    }
}

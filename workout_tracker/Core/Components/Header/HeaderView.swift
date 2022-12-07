//
//  HeaderView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct HeaderView: View {
    let headerText: String
    let subtitle: String?
    let includeDivider: Bool
    
    init(_ headerText: String, subtitle: String? = nil, includeDivider: Bool = false) {
        self.headerText = headerText
        self.subtitle = subtitle
        self.includeDivider = includeDivider
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(headerText)
                        .font(.largeTitle)
                        .bold()
                    
                    if subtitle != nil {
                        Text(subtitle!)
                            .foregroundColor(Color(.systemGray))
                    }
                }
                Spacer()
            }
            
            if includeDivider { Divider() }
        }
        .padding([.top, .horizontal])
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView("My Workouts", subtitle: CustomDateFormatter.dateFormatter.string(from: Date.now))
    }
}

//
//  LoadingView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct LoadingView: View {
    let includeBorder: Bool
    
    init(includeBorder: Bool = false) {
        self.includeBorder = includeBorder
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if includeBorder {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.25)
                        .foregroundColor(Color(.systemGray4))
                        .opacity(0.8)
                }
                
                LoadingIndicator(animation: .circleBars, speed: .fast)
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
        .background(Color.clear)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(includeBorder: true)
    }
}

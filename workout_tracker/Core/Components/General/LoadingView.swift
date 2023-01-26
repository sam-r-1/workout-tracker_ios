//
//  LoadingView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                LoadingIndicator(animation: .circleBars, speed: .fast)
                Spacer()
            }
           
            Spacer()
        }
        .background(Color.clear)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

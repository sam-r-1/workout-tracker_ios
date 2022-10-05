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
        VStack {
            Spacer()
            LoadingIndicator(animation: .circleBars, speed: .fast)
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

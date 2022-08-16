//
//  LoginView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        // parent container
        VStack {
            Spacer()
                           
            // Login card
            AuthCardView()
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .background(Color(.systemGray2))
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

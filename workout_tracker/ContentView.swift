//
//  ContentView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
            Group {
                // no user logged in
                if viewModel.userSession == nil {
                    LoginView()
                } else { // have a logged in user
                    MainTabView()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

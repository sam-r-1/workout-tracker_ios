//
//  MainTabView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var showMenu = false
    @State private var isActiveWorkout = false
    
    let tabBarHeight: CGFloat = UIScreen.main.bounds.height / 14
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MainTabViewBodyView(tabBarHeight: tabBarHeight)
                
                if showMenu {
                    // dim the rest of the screen
                    Rectangle()
                        .foregroundColor(.black)
                        .opacity(0.66)
                        .ignoresSafeArea()
                        .onTapGesture {
                            // dont allow users to tap on things below the rectangle object
                        }
                    
                    // display the popup options
                    PopUpMenuView($showMenu, $isActiveWorkout)
                        .padding(.bottom, 100)
                }
                
                TabMenuIconView(showMenu: $showMenu)
                    .onTapGesture {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                    .frame(height: tabBarHeight)
            }
        }
        .fullScreenCover(isPresented: $isActiveWorkout) {
            WorkoutView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

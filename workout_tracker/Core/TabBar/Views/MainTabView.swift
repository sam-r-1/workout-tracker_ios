//
//  MainTabView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var showMenu = false
    @State private var showNoExercisesMessage = false
    @State private var isActiveWorkout = false
    @StateObject var router = ViewRouter()
    
    let tabBarHeight: CGFloat = fmax(UIScreen.main.bounds.height / 14, 58.0)
    
    var body: some View {
         NavigationView {
            ZStack(alignment: .bottom) {
                MainTabViewBodyView(router: router, tabBarHeight: tabBarHeight)
                
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
                    PopUpMenuView(showMenu: $showMenu, showNoExercisesMessage: $showNoExercisesMessage, isActiveWorkout: $isActiveWorkout)
                        .padding(.bottom, 100)
                }
                
                TabMenuIconView(showMenu: $showMenu, router: router, offset: tabBarHeight * 0.3)
                    .onTapGesture {
                        withAnimation {
                            print("DEBUG: \(tabBarHeight)")
                            showMenu.toggle()
                        }
                    }
                    .frame(height: tabBarHeight)
            }
         }
            .alert("You must add at least one exercise from the Exercises tab to begin a workout.", isPresented: $showNoExercisesMessage, actions: {
                Button("Dismiss") { showNoExercisesMessage = false }
            })
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

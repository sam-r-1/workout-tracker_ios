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
    @State private var isSelectingTemplate = false
    @State private var selectedTemplate: Template? = nil
    @StateObject var router = ViewRouter()
    
    let tabBarHeight: CGFloat = fmax(UIScreen.main.bounds.height / 14, 58.0)

    var body: some View {
         NavigationView {
            ZStack(alignment: .bottom) {
                NavigationLink(isActive: $isSelectingTemplate) {
                    SelectTemplateView { template in
                        if template != nil {
                            self.selectedTemplate = template
                            self.isActiveWorkout = true
                        }
                    }
                } label: {
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(isActive: $isActiveWorkout) {
                    WorkoutView(workoutActive: $isActiveWorkout, fromTemplate: selectedTemplate)
                } label: {
                    EmptyView()
                }
                .hidden()

                
                MainTabViewBodyView(tabBarHeight: tabBarHeight)
                    .environmentObject(router)
                
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
                    PopUpMenuView(showMenu: $showMenu, showNoExercisesMessage: $showNoExercisesMessage, isActiveWorkout: $isActiveWorkout, isSelectingTemplate: $isSelectingTemplate, router: router)
                        .padding(.bottom, 100)
                }
                
                TabMenuIconView(showMenu: $showMenu, router: router, offset: tabBarHeight * 0.3)
                    .onTapGesture {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                    .frame(height: tabBarHeight)
            }
         }
         .alert(router.startWorkoutOption.emptyErrorMessage, isPresented: $showNoExercisesMessage, actions: {
                Button("Dismiss") { showNoExercisesMessage = false }
            })
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

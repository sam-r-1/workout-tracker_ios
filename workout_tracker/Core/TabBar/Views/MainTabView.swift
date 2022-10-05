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
    @State private var toggleTest = false
    @StateObject var router = ViewRouter()
    
    let tabBarHeight: CGFloat = UIScreen.main.bounds.height / 14
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    
                    router.view
                    
                    HStack {
                        Spacer()
                        TabIconView(viewModel: .exercises, router: router)
                        TabIconView(viewModel: .templates, router: router)
                        
                        // add an object with the same size as the start workout button to space the other tab bar buttons around it
                        Rectangle()
                            .foregroundColor(.clear)
                        
                        TabIconView(viewModel: .history, router: router)
                        TabIconView(viewModel: .settings, router: router)
                        
                        Spacer()

                    }
                    .frame(height: tabBarHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                }
                
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
                
                Button { toggleTest.toggle() } label: { Text("Test").foregroundColor(toggleTest ? .red : .blue)}
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

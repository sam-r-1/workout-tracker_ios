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
    @StateObject var router = ViewRouter()
    
    let tabBarHeight: CGFloat = UIScreen.main.bounds.height / 14
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    
                    router.view
                    
                    HStack {
                        Spacer()
                        TabIcon(viewModel: .exercises, router: router)
                        TabIcon(viewModel: .templates, router: router)
                        
                        // add an object with the same size as the start workout button to space the other tab bar buttons around it
                        Rectangle()
                            .foregroundColor(.clear)
                        
                        TabIcon(viewModel: .history, router: router)
                        TabIcon(viewModel: .settings, router: router)
                        
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
                
                TabMenuIcon(showMenu: $showMenu)
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

struct TabMenuIcon: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .shadow(radius: 4)
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(showMenu ? Color(.systemRed) : Color(.systemBlue))
                    .rotationEffect(Angle(degrees: showMenu ? 45 : 0))
            }
            
            
            Text("Workout")
                .font(.caption)
        }
        .offset(y: -20)
    }
}

struct TabIcon: View {
    let viewModel: TabBarViewModel
    @ObservedObject var router: ViewRouter
    
    let selectedScaleFactor: CGFloat = 1.1
    
    var body: some View {
        let isSelected = router.currentItem == viewModel
        
        Button {
            if router.currentItem != viewModel {
                router.currentItem = viewModel
            }
        } label: {
            VStack {
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                
                Text(viewModel.title)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
            }
        }
        .foregroundColor(.primary)
        .scaleEffect(x: isSelected ? selectedScaleFactor : 1.0,
                     y: isSelected ? selectedScaleFactor : 1.0,
                     anchor: .center)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

//
//  MainTabView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var showMenu = false;
    // @State private var selectedIndex = 0
    @ObservedObject var router = ViewRouter()
    
    var body: some View {
        VStack {
            Spacer()
            
            router.view
            
            Spacer()
            
            HStack(alignment: .top) {
                Spacer()
                TabIcon(viewModel: .exercises, router: router)
                TabIcon(viewModel: .templates, router: router)
                
                TabMenuIcon(showMenu: $showMenu)
                    .onTapGesture {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                
                TabIcon(viewModel: .history, router: router)
                TabIcon(viewModel: .visualize, router: router)
                
                Spacer()

            }
            .frame(height: UIScreen.main.bounds.height / 8)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

struct TabMenuIcon: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .shadow(radius: 4)
            
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.systemBlue))
                .rotationEffect(Angle(degrees: showMenu ? 45 : 0))
        }
        .offset(y: -44)
    }
}

struct TabIcon: View {
    let viewModel: TabBarViewModel
    @ObservedObject var router: ViewRouter
    
    var body: some View {
        Button {
            router.currentItem = viewModel
        } label: {
            VStack {
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                
                Text(viewModel.title)
                    .font(.subheadline)
                    .fixedSize()
                    .foregroundColor(.white)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

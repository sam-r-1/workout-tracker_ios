//
//  MainTabViewBodyView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct MainTabViewBodyView: View {
    @ObservedObject var router: ViewRouter
    let tabBarHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            
            router.view
            
            HStack(alignment: .center) {
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
    }
}

struct MainTabViewBodyView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabViewBodyView(router: ViewRouter(), tabBarHeight: 50)
    }
}

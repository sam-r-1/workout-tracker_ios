//
//  TabIconView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct TabIconView: View {
    @Environment(\.legibilityWeight) var ledgibilityWeight
    
    let option: TabBarOption
    @EnvironmentObject var router: ViewRouter
    
    let selectedScaleFactor: CGFloat = 1.1

    var body: some View {        
        Button {
            router.toggleSelected(for: option)
        } label: {
            VStack {
                option.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity)
                    // fix for dark mode with custom icons for Exercises and Templates
                    .invertOnDarkTheme(option == .exercises || option == .templates)
                    .scaleEffect(
                        x: router.isSelected(option) ? selectedScaleFactor : 1.0,
                        y: router.isSelected(option) ? selectedScaleFactor : 1.0,
                        anchor: .center
                    )
                
                Text(option.title)
                    .font(.system(size: router.tabBarTextSize()))
                    .fontWeight(router.isSelected(option) ? .bold : .regular)
                    .lineLimit(1)
                    .scaleEffect(
                        x: (router.isSelected(option) && ledgibilityWeight != .bold) ? selectedScaleFactor : 1.0,
                        y: (router.isSelected(option) && ledgibilityWeight != .bold) ? selectedScaleFactor : 1.0,
                        anchor: .center
                    )
            }
        }
        .foregroundColor(.primary)
    }
}

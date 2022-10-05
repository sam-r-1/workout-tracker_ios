//
//  TabIconView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct TabIconView: View {
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

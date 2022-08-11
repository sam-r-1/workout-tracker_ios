//
//  PopUpMenuView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct PopUpMenuView: View {
    var body: some View {
        HStack(spacing: 36) {
            Spacer()
            
            ForEach(PopUpMenuViewModel.allCases, id: \.self) { item in
                MenuItem(viewModel: item)
            }
            
            Spacer()
        }
        .transition(.scale)
    }
}

struct MenuItem: View {
    let viewModel: PopUpMenuViewModel;
    let size: CGFloat = 48
    
    var body: some View {
        Button {
            print("starting a workout")
        }
        label: {
            ZStack {
                Capsule()
                    .foregroundColor(Color(.systemBlue))
                    .frame(height: size)
                    .shadow(radius: 4)
                
                Text(viewModel.title)
                    .padding(2)
                    .foregroundColor(.white)
                    .font(.footnote)
            }
        }
    }
}

struct PopUpMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpMenuView()
    }
}

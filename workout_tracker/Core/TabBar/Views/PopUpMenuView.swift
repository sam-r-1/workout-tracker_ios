//
//  PopUpMenuView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct PopUpMenuView: View {
    @Binding var showMenu: Bool
    @Binding var isActiveWorkout: Bool
    
    init(_ showMenu: Binding<Bool>, _ isActiveWorkout: Binding<Bool>) {
        self._showMenu = showMenu
        self._isActiveWorkout = isActiveWorkout
    }
    
    var body: some View {
        HStack(spacing: 36) {
            Spacer()
            
            ForEach(PopUpMenuViewModel.allCases, id: \.self) { item in
                MenuItem(viewModel: item, showMenu: $showMenu, isActiveWorkout: $isActiveWorkout)
            }
            
            Spacer()
        }
        .transition(.scale)
    }
}

struct MenuItem: View {
    let viewModel: PopUpMenuViewModel;
    let size: CGFloat = 48
    @Binding var showMenu: Bool
    @Binding var isActiveWorkout: Bool
    
    var body: some View {
        Button {
            print("starting a workout")
            $showMenu.wrappedValue = false
            $isActiveWorkout.wrappedValue.toggle()
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
        PopUpMenuView(.constant(true), .constant(false))
    }
}

//
//  PopUpMenuView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct PopUpMenuView: View {
    @Binding var showMenu: Bool
    @Binding var showNoExercisesMessage: Bool
    @Binding var isActiveWorkout: Bool
    @ObservedObject var router: ViewRouter
    @StateObject var viewModel = PopUpMenuViewModel()
    
    var body: some View {
        HStack(spacing: 36) {
            Spacer()
            
            ForEach(PopUpMenuOption.allCases, id: \.self) { item in
                MenuItem(router: router, viewModel: viewModel, option: item, showMenu: $showMenu, showNoExercisesMessage: $showNoExercisesMessage, isActiveWorkout: $isActiveWorkout)
            }
            
            Spacer()
        }
        .transition(.scale)
    }
}

struct MenuItem: View {
    let router: ViewRouter
    let viewModel: PopUpMenuViewModel
    let option: PopUpMenuOption
    let size: CGFloat = 48
    @Binding var showMenu: Bool
    @Binding var showNoExercisesMessage: Bool
    @Binding var isActiveWorkout: Bool
    
    var body: some View {
        Button {
            $showMenu.wrappedValue = false
            viewModel.canStartWorkout(option) { yes in
                if yes {
                    router.startWorkoutOption = option
                    $isActiveWorkout.wrappedValue.toggle()
                }
                else { $showNoExercisesMessage.wrappedValue.toggle() }
            }
        }
        label: {
            ZStack {
                Capsule()
                    .foregroundColor(Color(.systemBlue))
                    .frame(height: size)
                    .shadow(radius: 4)
                
                Text(option.title)
                    .padding(2)
                    .foregroundColor(.white)
                    .font(.footnote)
            }
        }
    }
}

struct PopUpMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpMenuView(showMenu: .constant(false), showNoExercisesMessage: .constant(false), isActiveWorkout: .constant(false), router: ViewRouter())
    }
}

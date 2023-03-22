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
    @Binding var isSelectingTemplate: Bool
    @ObservedObject var router: ViewRouter
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            ForEach(PopUpMenuOption.allCases, id: \.self) { item in
                HStack {
                    Spacer()
                    
                    MenuItem(router: router, viewModel: viewModel, option: item, showMenu: $showMenu, showNoExercisesMessage: $showNoExercisesMessage, isActiveWorkout: $isActiveWorkout, isSelectingTemplate: $isSelectingTemplate)
                    
                    Spacer()
                }
            }
        }
        .transition(.scale)
    }
}

struct MenuItem: View {
    @Environment(\.sizeCategory) var sizeCategory
    let router: ViewRouter
    let viewModel: PopUpMenuView.ViewModel
    let option: PopUpMenuOption
    let size: CGFloat = 48
    @Binding var showMenu: Bool
    @Binding var showNoExercisesMessage: Bool
    @Binding var isActiveWorkout: Bool
    @Binding var isSelectingTemplate: Bool
    
    var body: some View {
        Button {
            $showMenu.wrappedValue = false

            Task {
                if await viewModel.canStartWorkout(option) {
                    switch option {
                        case .fromScratch: isActiveWorkout = true
                        case .fromTemplate: isSelectingTemplate = true
                    }
                } else {
                    $showNoExercisesMessage.wrappedValue.toggle()
                }
            }
        }
        label: {
            
            Text(option.title)
                .padding(.vertical, 12)
                .padding(.horizontal, sizeCategory.isAccessibilityCategory ? 40 : 12)
                .foregroundColor(.white)
                .background(Color(.systemBlue))
                .font(.callout)
                .clipShape(Capsule())
                .shadow(radius: 4)
        }
    }
}

struct PopUpMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpMenuView(showMenu: .constant(false), showNoExercisesMessage: .constant(false), isActiveWorkout: .constant(false), isSelectingTemplate: .constant(false), router: ViewRouter())
    }
}

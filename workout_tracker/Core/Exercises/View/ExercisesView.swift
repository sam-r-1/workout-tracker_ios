//
//  ExcercisesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct ExercisesView: View {
    @State private var showModifyExerciseView = false
    @ObservedObject var viewModel = ExercisesViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack {

                AddNewHeaderView(title: "My Exercises",
                                 showView: $showModifyExerciseView,
                                 view: AnyView(ModifyExerciseView(parentViewModel: viewModel)))
                
                switch viewModel.loadingState {
                    case .data: dataView
                        
                    case .loading: LoadingView()
                        
                    case .error: Text("--") // placeholder for error message; should never be used currently
                }
            }
            .navigationBarHidden(true)
        }
    }
}

extension ExercisesView {
    var dataView: some View {
        VStack(spacing: 8) {
            if viewModel.exercises.isEmpty {
                noDataView
            } else {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 20)
                
                List {
                    ForEach(viewModel.searchableExercises) {exercise in
                        NavigationLink {
                            NavigationLazyView(ModifyExerciseView(parentViewModel: viewModel, exercise: exercise))
                        } label: {
                            ExerciseRowView(exercise)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
    
    var noDataView: some View {
        VStack {
            Spacer()
            
            Text("You don't have any exercises yet.\n Add some to get started.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(viewModel: ExercisesViewModel(forPreview: true))
    }
}

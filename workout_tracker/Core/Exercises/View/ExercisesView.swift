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

extension ExercisesView {
    var dataView: some View {
        VStack {
            if viewModel.exercises.isEmpty {
                noDataView
            } else {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.searchableExercises) {exercise in
                            NavigationLink {
                                NavigationLazyView(ModifyExerciseView(parentViewModel: viewModel, exercise: exercise))
                            } label: {
                                ExerciseRowView(
                                    exercise: exercise,
                                    trailingIcon: AnyView(Image(systemName: "arrow.right").foregroundColor(.gray))
                                )
                            }
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
        ExercisesView()
    }
}

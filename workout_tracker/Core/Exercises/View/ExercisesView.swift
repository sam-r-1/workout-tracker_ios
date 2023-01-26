//
//  ExcercisesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct ExercisesView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    @State private var showModifyExerciseView = false
    @StateObject var viewModel = ExercisesViewModel()
    
    var body: some View {
        Group {
            switch viewModel.loadingState {
                case .data: dataView
                    
                case .loading: LoadingView()
                    
                case .error: Text("--") // placeholder for error message; should never be used currently
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Exercises")
        .navigationBarTitleDisplayMode(sizeCategory > .accessibilityExtraLarge ? .inline : .automatic)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ModifyExerciseView(parentViewModel: viewModel)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
}

extension ExercisesView {
    var dataView: some View {
        Group {
            if viewModel.exercises.isEmpty {
                noDataView
            } else {
                List {
                    ForEach(viewModel.searchableExercises) {exercise in
                        NavigationLink {
                            NavigationLazyView(ModifyExerciseView(parentViewModel: viewModel, exercise: exercise))
                        } label: {
                            ExerciseRowView(exercise)
                        }
                    }
                }
                .searchable(text: $viewModel.searchText)
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
        NavigationView {
            ExercisesView(viewModel: ExercisesViewModel(forPreview: true))
        }
        
        NavigationView {
            ExercisesView(viewModel: ExercisesViewModel(forPreview: true))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}

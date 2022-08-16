//
//  ExcercisesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct ExercisesView: View {
    @State private var showAddExerciseView = false
    @ObservedObject var viewModel = ExercisesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {

            AddNewHeaderView(title: "My Exercises",
                             showView: $showAddExerciseView,
                             view: AnyView(AddExerciseView()))
            
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchableExercises) {exercise in
                        ExerciseRowView(exercise: exercise)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}

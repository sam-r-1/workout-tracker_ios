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
    
    @EnvironmentObject var authViewModel: AuthViewModel //temporary
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // temporary
            Button {
                authViewModel.signOut()
            } label: {
                Text("Sign out")
            }
            // end temporary

            AddNewHeaderView(title: "My Exercises",
                             showView: $showAddExerciseView,
                             view: AnyView(AddExerciseView()))
            
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(1...20, id: \.self) {_ in
                       ExerciseRowView()
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

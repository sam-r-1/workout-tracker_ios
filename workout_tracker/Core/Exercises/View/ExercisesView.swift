//
//  ExcercisesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct ExercisesView: View {
    @ObservedObject var viewModel = ExercisesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                // page title
                Text("My Exercises")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                //Button to add new exercise
                Button {
                    print("DEBUG: add new exercise")
                } label: {
                    VStack {
                        Image(systemName: "plus")
                        Text("New")
                    }
                }
                .padding(.trailing, 10)

            }
            .padding([.top, .horizontal])
            
            SearchBar(text: $viewModel.searchText)
                .padding([.horizontal])
            
            ScrollView {
                LazyVStack {
                    ForEach(1...20, id: \.self) {_ in
                       ExerciseRowView()
                            .padding()
                    }
                }
            }
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}

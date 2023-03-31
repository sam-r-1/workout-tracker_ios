//
//  SelectExerciseView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/18/22.
//

import SwiftUI

struct SelectExerciseView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    let onAdd: (String) async -> Void
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                }
                
                Text("Select an Exercise")
                    .font(.title)
                    .bold()
                
                switch viewModel.loadingState {
                    case .data: dataView
                        
                    case .loading: LoadingView()
                        
                    case .error: errorView
                }
            }
        }
        .task {
            await viewModel.fetchExercises()
        }
    }
}

extension SelectExerciseView {
    var dataView: some View {
        VStack {

            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal, 20)
            
            List {
                ForEach(viewModel.searchableExercises) {exercise in
                    ExerciseRowView(
                        exercise,
                        trailingIcon: AnyView(
                            Button {
                                Task {
                                    await onAdd(exercise.id!)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                if self.sizeCategory.isAccessibilityCategory {
                                    Image(systemName: "plus")
                                } else {
                                    Text("Add")
                                }
                            }
                                .foregroundColor(Color(.systemBlue))
                        )
                    )
                }
            }
        }
    }
    
    var errorView: some View {
        VStack {
            Spacer()
            
            Text("There was an error retrieving your exercises.\n Please try again later.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
        }
    }
}

struct SelectExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExerciseView() { _ in
            //
        }
    }
}

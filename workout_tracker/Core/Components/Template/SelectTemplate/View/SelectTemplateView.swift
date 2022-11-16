//
//  SelectTemplateView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/14/22.
//

import SwiftUI

struct SelectTemplateView: View {
    @Binding var workoutActive: Bool
    @StateObject var viewModel = SelectTemplateViewModel()
    var gridLayout = [ GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    workoutActive = false
                }
                .padding(.leading, 12)
                
                Spacer()
            }
            
            Text("Select a Template")
                .font(.title)
                .bold()

            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 12) {
                    ForEach(viewModel.searchableTemplates) {item in
                        NavigationLink {
                            WorkoutView(workoutActive: $workoutActive, fromTemplate: item)
                        } label: {
                            TemplateGridView(item)
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .navigationBarHidden(true)
    }
}

struct SelectTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTemplateView(workoutActive: Binding.constant(true))
    }
}
//
//  SelectTemplateView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/14/22.
//

import SwiftUI

struct SelectTemplateView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    @Binding var workoutActive: Bool
    @StateObject var viewModel = SelectTemplateViewModel()
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
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
                    .padding(.horizontal, 20)
                
                ScrollView {
                    LazyVGrid(
                        columns: sizeCategory.isAccessibilityCategory
                        ? [ GridItem(.flexible(), spacing: 12)]
                        : [ GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(viewModel.searchableTemplates) {item in
                            NavigationLink {
                                WorkoutView(workoutActive: $workoutActive, fromTemplate: item)
                            } label: {
                                TemplateGridView(item)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

struct SelectTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTemplateView(workoutActive: Binding.constant(true), viewModel: SelectTemplateViewModel(forPreview: true))
    }
}

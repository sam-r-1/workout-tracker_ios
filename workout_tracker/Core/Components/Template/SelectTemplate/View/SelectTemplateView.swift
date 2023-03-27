//
//  SelectTemplateView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/14/22.
//

import SwiftUI

struct SelectTemplateView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.presentationMode) var presentationMode
    let onTemplateSelected: (Template?) -> Void
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                }
                
                Text("Select a Template")
                    .font(.title)
                    .bold()

                switch viewModel.loadingState {
                    case .data: dataView
                        
                    case .loading: LoadingView()
                        
                    case .error: errorView
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchTemplates()
        }
        .onDisappear{
            onTemplateSelected(viewModel.selectedTemplate)
        }
    }
}

extension SelectTemplateView {
    var dataView: some View {
        VStack(spacing: 45) {
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
                        Button {
                            viewModel.selectedTemplate = item
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            TemplateGridView(item)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var errorView: some View {
        VStack {
            Spacer()
            
            Text("There was an error retrieving your templates.\n Please try again later.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
        }
    }
}

struct SelectTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTemplateView() { _ in }
    }
}

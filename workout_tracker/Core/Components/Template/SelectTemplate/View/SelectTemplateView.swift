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
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = SelectTemplateViewModel()
    
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
            .navigationBarHidden(true)
        }
        .onDisappear{
            onTemplateSelected(viewModel.selectedTemplate)
        }
    }
}

struct SelectTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTemplateView(viewModel: SelectTemplateViewModel(forPreview: true)) { template in
            //
        }
    }
}

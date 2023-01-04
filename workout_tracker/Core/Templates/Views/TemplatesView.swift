//
//  TemplatesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct TemplatesView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    @State private var showModifyTemplateView = false
    @StateObject var viewModel = TemplatesViewModel()
    
    var body: some View {
        Group {
            switch viewModel.loadingState {
                case .data: dataView
                    
                case .loading: LoadingView()
                    
                case .error: Text("--") // placeholder for error message; should never be used currently
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Templates")
        .navigationBarTitleDisplayMode(sizeCategory > .accessibilityExtraLarge ? .inline : .automatic)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ModifyTemplateView()
                        .onDisappear {
                            viewModel.loadingState = .loading
                            viewModel.fetchTemplates()
                        }
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
}
    
extension TemplatesView {
    var dataView: some View {
        Group {
            if viewModel.templates.isEmpty {
                noDataView
            } else {
                    ScrollView {
                        VStack {
                            LazyVGrid(
                                columns: sizeCategory.isAccessibilityCategory
                                ? [ GridItem(.flexible(), spacing: 12)]
                                : [ GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                                spacing: 12
                            ) {
                                ForEach(viewModel.searchableTemplates) {item in
                                    NavigationLink {
                                        ModifyTemplateView(template: item)
                                    } label: {
                                        TemplateGridView(item)
                                    }
                                }
                        }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal, 20)
                    .searchable(text: $viewModel.searchText)
            }
        }
    }
    
    var noDataView: some View {
        VStack {
            Spacer()
            
            Text("You don't have any templates yet.\n Add some from this screen.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
        }
    }
}

struct TemplatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TemplatesView(viewModel: TemplatesViewModel(forPreview: true))
        }
            
        NavigationView {
            TemplatesView(viewModel: TemplatesViewModel(forPreview: true))
        }
        .previewDevice("iPhone SE (3rd generation)")
    }
}

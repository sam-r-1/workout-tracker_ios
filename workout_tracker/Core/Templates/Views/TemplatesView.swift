//
//  TemplatesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct TemplatesView: View {
    @State private var showModifyTemplateView = false
    @ObservedObject var viewModel = TemplatesViewModel()
    
    private var gridLayout = [ GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    
    var body: some View {
        VStack {
            AddNewHeaderView(title: "My Templates",
                             showView: $showModifyTemplateView,
                             view: AnyView(ModifyTemplateView()
                                .onDisappear(perform: {
                                    viewModel.loadingState = .loading
                                    viewModel.fetchTemplates()
                                })
                             )
            )
            
            switch viewModel.loadingState {
                case .data: dataView
                    
                case .loading: LoadingView()
                    
                case .error: Text("--") // placeholder for error message; should never be used currently
            }
        }
        .navigationBarHidden(true)
    }
}
    
extension TemplatesView {
    var dataView: some View {
        Group {
            if viewModel.templates.isEmpty {
                noDataView
            } else {
                SearchBar(text: $viewModel.searchText)
                    .padding([.horizontal])

                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 12) {
                        ForEach(viewModel.searchableTemplates) {item in
                            NavigationLink {
                                ModifyTemplateView(template: item)
                            } label: {
                                TemplateGridView(item)
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
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
        TemplatesView()
    }
}

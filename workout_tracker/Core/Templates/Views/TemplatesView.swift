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
    @ObservedObject var viewModel = TemplatesViewModel()
    
    init(viewModel: TemplatesViewModel = TemplatesViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
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
}
    
extension TemplatesView {
    var dataView: some View {
        VStack(spacing: 20) {
            if viewModel.templates.isEmpty {
                noDataView
            } else {
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
                                ModifyTemplateView(template: item)
                            } label: {
                                TemplateGridView(item)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
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
        Group {
            TemplatesView(viewModel: TemplatesViewModel(forPreview: true))
                .preferredColorScheme(.dark)
            
            TemplatesView(viewModel: TemplatesViewModel(forPreview: true))
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDevice("iPhone SE (3rd generation)")
        }
    }
}

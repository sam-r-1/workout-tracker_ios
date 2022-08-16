//
//  TemplatesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct TemplatesView: View {
    @State private var showAddTemplateView = false
    @ObservedObject var viewModel = TemplatesViewModel()
    
    private var gridLayout = [ GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    
    var body: some View {
        VStack(alignment: .leading) {
            AddNewHeaderView(title: "My Templates",
                             showView: $showAddTemplateView, view: AnyView(Text("Add a template here")))
            
            SearchBar(text: $viewModel.searchText)
                .padding([.horizontal])
            
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 12) {
                    ForEach(1...4, id: \.self) {_ in
                        TemplateGridView()
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .navigationBarHidden(true)
    }
}

struct TemplatesView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatesView()
    }
}

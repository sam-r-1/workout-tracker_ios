//
//  SearchBar.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search...", text: $text)
            .padding(6.0)
            .padding(.horizontal, 24)
            .background(Color(.systemGray5))
            .cornerRadius(8.0)
            .overlay {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8.0)
                }
            }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack {
                SearchBar(text: .constant(""))
                    .padding(.horizontal, 20)
                
                List {
                    ForEach(1...5, id: \.self) {
                        Text("\($0)")
                    }
                }
            }
        }
    }
}

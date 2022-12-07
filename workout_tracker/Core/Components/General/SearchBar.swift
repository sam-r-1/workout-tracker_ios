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
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .aspectRatio(1.0, contentMode: .fit)
                
            TextField("Search...", text: $text)
            
            Spacer()
                        
        }
        .padding(6)
        .padding(.leading, 8.0)
        .background(Color(.systemGray5))
        .cornerRadius(8.0)
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

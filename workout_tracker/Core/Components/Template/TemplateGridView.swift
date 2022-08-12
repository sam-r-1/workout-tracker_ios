//
//  TemplateGridView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct TemplateGridView: View {
    let columnCount: Int = 2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Leg Day")
                    .bold()
                .font(.title3)
                
                Spacer()
                
                Button {
                    print("DEBUG: open template options")
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundColor(.primary)
            .padding(.trailing, 8)
            
            Divider()
            
            VStack(alignment: .leading) {
                ForEach(1...4, id: \.self) {_ in
                    Text("3 x Leg Press")
                        .font(.body)
                        .padding(.leading, 8)
                }
                
                Text("+ 2 more")
                    .font(.subheadline)
                    .padding(.leading, 16)
            }
            .foregroundColor(.secondary)
            
            
        }
        .padding(8)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}

struct TemplateGridView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateGridView()
    }
}

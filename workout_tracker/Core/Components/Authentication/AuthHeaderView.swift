//
//  AuthHeaderView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct AuthHeaderView: View {
    let logoImage: String
    let line1Text: String
    
    var body: some View {
        VStack(alignment: .center) {
            HStack { Spacer() }
            
            Image(systemName: logoImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
            
            Text(line1Text)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
        }
        .frame(height: 160)
        .padding(.leading)
        .background(.clear)
        .foregroundColor(.primary)
        // .clipShape(RoundedShape(corners: [.bottomRight]))
    }
}

struct AuthHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AuthHeaderView(logoImage: "globe", line1Text: "Hello.")
    }
}

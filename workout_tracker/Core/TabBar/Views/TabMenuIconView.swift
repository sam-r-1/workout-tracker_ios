//
//  TabMenuIconView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct TabMenuIconView: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .shadow(radius: 4)
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(showMenu ? Color(.systemRed) : Color(.systemBlue))
                    .rotationEffect(Angle(degrees: showMenu ? 45 : 0))
            }
            
            
            Text("Workout")
                .font(.caption)
        }
        .offset(y: -20)
    }
}

//struct TabMenuIconView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabMenuIconView(showMenu: )
//    }
//}

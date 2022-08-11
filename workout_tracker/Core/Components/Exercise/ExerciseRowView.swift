//
//  ExerciseRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct ExerciseRowView: View {
    var body: some View {
        HStack() {
            VStack {
                Text("An exercise")
                    .font(.title2)
                    .bold()
                
                Text("Arms")
                
                Text("Time, Reps")
            }
            
            Spacer()
            
            Button {
                print("DEBUG: open exercise options")
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }

        }
        .padding(.horizontal)
        .foregroundColor(.black)
    }
}

struct ExerciseRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRowView()
    }
}

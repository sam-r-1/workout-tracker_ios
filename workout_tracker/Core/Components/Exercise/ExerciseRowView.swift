//
//  ExerciseRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct ExerciseRowView: View {
    let exercise: Exercise
    let trailingIcon: AnyView
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.title2)
                        .bold()
                    
                    Text(exercise.type)
                    
                    Text(exercise.dataFieldTextList())
                }
                .foregroundColor(.primary)
                
                Spacer()
                
                trailingIcon
            }
            .padding(.horizontal)
        }
    }
}

//struct ExerciseRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseRowView()
//    }
//}

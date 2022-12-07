//
//  ExerciseRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

struct ExerciseRowView: View {
    let exercise: Exercise
    let trailingIcon: AnyView?
    
    init(_ exercise: Exercise, trailingIcon: AnyView? = nil) {
        self.exercise = exercise
        self.trailingIcon = trailingIcon
    }
    
    var body: some View {
        HStack(spacing: 30) {
            Text(exercise.name)
                .font(.title3)
            
            HStack(spacing: 15) {
                exercise.dataFieldIcons()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.systemGray))
            }
            
            Spacer()
            
            trailingIcon
        }
        .foregroundColor(.primary)
    }
}

struct ExerciseRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRowView(MockService.sampleExercises[0])
    }
}

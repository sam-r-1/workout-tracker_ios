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
    @ScaledMetric(relativeTo: .title3) var iconSize: CGFloat = 18.0
    
    init(_ exercise: Exercise, trailingIcon: AnyView? = nil) {
        self.exercise = exercise
        self.trailingIcon = trailingIcon
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.name)
                    .font(.title3)
                
                HStack(spacing: 15) {
                    exercise.dataFieldIcons()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(Color(.systemGray))
                }
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

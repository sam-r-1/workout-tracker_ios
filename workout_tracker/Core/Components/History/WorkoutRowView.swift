//
//  WorkoutRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 25) {
            DateIcon(date: workout.timestamp.dateValue())
                .frame(width: 55)
            
            Group {
                if workout.exerciseInstanceIdList.count == 1 {
                    Text("1 Exercise")
                        .lineLimit(1)
                } else {
                    Text("\(workout.exerciseInstanceIdList.count) Exercises")
                        .lineLimit(1)
                }
            }
            .font(.system(.headline))
            
            Spacer()
        }
        .foregroundColor(.primary)
        .padding(8)
    }
}

struct WorkoutRowView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRowView(workout: MockService.sampleWorkouts[0])
    }
}

//
//  WorkoutRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout
    
    @State private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(dateFormatter.string(from: workout.timestamp.dateValue()))
                                .font(.title2)
                                .bold()
                            
                            
                            if workout.exerciseInstanceIdList.count == 1 {
                                Text("1 Exercise")
                            } else {
                                Text("\(workout.exerciseInstanceIdList.count) Exercises")
                            }
                        }
                        
                        Spacer()

                    }
                    .foregroundColor(.primary)
                }
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
    }
}

//struct WorkoutRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutRowView(workout: Workout(uid: "", timestamp: Timestamp(), exerciseInstanceIdList: ["id1", "id2", "id3"]))
//    }
//}

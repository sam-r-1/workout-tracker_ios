//
//  WorkoutDetailsView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    let workout: Workout
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    
    @State private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    init(_ workout: Workout) {
        self.workout = workout
        self.viewModel = WorkoutDetailsViewModel(workout)
    }
    
    var body: some View {
        
        VStack {
            Text("Workout Data")
                .font(.largeTitle)
                .bold()
            
            Spacer(minLength: 12)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                        InstanceHistoryRowView(instance)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 4)
                    }
                }
                
                Spacer()
            }
            .navigationTitle(dateFormatter.string(from: workout.timestamp.dateValue()))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct WorkoutDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailsView(workout: Workout(uid: "", timestamp: Timestamp(), exerciseInstanceIdList: ["id1", "id2", "id3"]))
//    }
//}

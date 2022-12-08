//
//  SwiftUIView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct PreviousInstanceDataView: View {
    let exercise: Exercise
    @ObservedObject var viewModel: ExerciseInstanceViewModel
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.viewModel = ExerciseInstanceViewModel(exercise.id!)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if self.viewModel.showPrev {
                Text(CustomDateFormatter.dateFormatter.string(from: viewModel.prevDate!))
                
                if exercise.includeWeight {
                    Text(WeightFormatter.weight.string(from: viewModel.prevWeight! as NSNumber) ?? "0.0")
                        .font(.title3)
                }
                
                if exercise.includeReps {
                    Text("\(viewModel.prevReps!)")
                        .font(.title3)
                }
                
                if exercise.includeTime {
                    Text(TimeFormatter.durationResult.string(from: viewModel.prevTime!) ?? "0s")
                        .font(.title3)
                }
            }
        }
        .foregroundColor(Color(.systemGray))
    }
}

//struct PreviousInstanceDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviousInstanceDataView()
//    }
//}

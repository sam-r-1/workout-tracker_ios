//
//  SwiftUIView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct PreviousInstanceDataView: View, Equatable {
    let exercise: Exercise
    @ObservedObject var viewModel: ExerciseInstanceViewModel
    
    static func == (lhs: PreviousInstanceDataView, rhs: PreviousInstanceDataView) -> Bool {
        return lhs.exercise.id == rhs.exercise.id
    }
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.viewModel = ExerciseInstanceViewModel(exercise.id!)
    }
    
    // Formatters
    @State private var doubleFormatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter
    }()
    
    @State private var timeFormatter: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.zeroFormattingBehavior = .dropLeading
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.allowsFractionalUnits = true
        timeFormatter.unitsStyle = .abbreviated
        return timeFormatter
    }()
    
    @State private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        VStack(spacing: 6) {
            if self.viewModel.showPrev {
                Text(dateFormatter.string(from: viewModel.prevDate!))
                   .underline()
                
                if exercise.includeWeight {
                    Text(doubleFormatter.string(from: viewModel.prevWeight! as NSNumber) ?? "0.0")
                        .font(.title3)
                }
                
                if exercise.includeReps {
                    Text("\(viewModel.prevReps!)")
                        .font(.title3)
                }
                
                if exercise.includeTime {
                    Text(timeFormatter.string(from: viewModel.prevTime!) ?? "0s")
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

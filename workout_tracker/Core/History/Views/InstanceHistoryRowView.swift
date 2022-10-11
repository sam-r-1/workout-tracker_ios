//
//  InstanceHistoryRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct InstanceHistoryRowView: View {
    @State private var showDeleteDialog = false
    let instance: ExerciseInstance
    @ObservedObject var viewModel : InstanceHistoryRowViewModel
    let onDelete: (String) -> Void
    
    // Formatters
    @State private var intFormatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .none
        return numFormatter
    }()
    
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

    init(_ instance: ExerciseInstance, onDelete: @escaping (String) -> Void) {
        self.instance = instance
        self.viewModel = InstanceHistoryRowViewModel(fromExerciseId: instance.exerciseId)
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let exercise: Exercise = viewModel.exercise {
                HStack {
                    Text(exercise.name)
                        .bold()
                        .font(.title)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        showDeleteDialog.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 5) {
                    if exercise.includeWeight {
                        HStack {
                            Text("Weight: ")
                            Text("\(doubleFormatter.string(from: instance.weight as NSNumber) ?? "0")lbs")
                        }
                    }
                    
                    if exercise.includeReps {
                        HStack {
                            Text("Reps:     ")
                            Text(intFormatter.string(from: instance.reps as NSNumber) ?? "Error loading")
                        }
                    }
                    
                    if exercise.includeTime {
                        HStack {
                            Text("Time:     ")
                            Text(timeFormatter.string(from: instance.time) ?? "Error loading")
                        }
                    }
                }
                .font(.title3)
                .padding(.leading)
            } else {
                LoadingIndicator(animation: .circleBars, speed: .fast)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .alert("Delete \(viewModel.exercise?.name ?? "") data from this workout?", isPresented: $showDeleteDialog) {
            Button("Delete", role: .destructive) {
                onDelete(instance.id!)
            }
        }
    }
}

//struct InstanceHistoryRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstanceHistoryRowView()
//    }
//}

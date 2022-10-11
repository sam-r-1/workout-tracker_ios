//
//  ExerciseResultRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/6/22.
//

import SwiftUI

struct ExerciseResultRowView: View {
    @State private var showDeleteDialog = false
    let exercise: Exercise
    let instance: ExerciseInstance
    let onDelete: (String) -> Void
    
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
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(dateFormatter.string(from: instance.timestamp.dateValue()))
                        .bold()
                        .font(.title2)
                    
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
                                Text("\(instance.reps)")
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
                }
                
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
        }
        .padding(.horizontal)
        .alert("Delete \(exercise.name) data from \(dateFormatter.string(from: instance.timestamp.dateValue()))?", isPresented: $showDeleteDialog) {
            Button("Delete", role: .destructive) {
                onDelete(instance.id!)
            }
        }
    }
}

//struct ExerciseResultRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseResultRowView()
//    }
//}

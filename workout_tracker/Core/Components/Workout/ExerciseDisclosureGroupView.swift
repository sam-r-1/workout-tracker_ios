//
//  ExerciseDisclosureGroupView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import SwiftUI

struct ExerciseDisclosureGroupView: View {
    @State private var showTimer = false
    @State private var isExpanded: Bool = true
    @State var item: ExerciseDataFields
    @ObservedObject var viewModel: ExerciseInstanceViewModel
    
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
    
    @State private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    init(item: ExerciseDataFields) {
        self.item = item
        
        self.viewModel = ExerciseInstanceViewModel(item.exercise.id!)
    }
    
    // View body
    var body: some View {
               
        DisclosureGroup(isExpanded: $isExpanded) {
            Divider()
            
            VStack {
                HStack {
                    Text("Today")
                        .bold()
                    
                    Spacer()
                    if viewModel.showPrev && viewModel.prevDate != nil {
                        Text(dateFormatter.string(from: viewModel.prevDate!))
                            .foregroundColor(Color(.systemGray))
                            .underline()
                    }
                }
                
                if item.exercise.includeWeight {
                    weightFieldView
                }

                if item.exercise.includeReps {
                    repsFieldView
                }

                if item.exercise.includeTime {
                    timeFieldView
                }
            }
            
        } label: {
            HStack {
                Text(item.exercise.name)
                    .bold()
                
                // Text("(set 1 of 3)") *Placeholder for potential set count text
            }
            .font(.title2)
        }
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .fullScreenCover(isPresented: $showTimer) {
            print("DEBUG: timer dismissed")
        } content: {
            TimerView(item, title: item.exercise.name)
        }
    }
}

struct ExerciseDisclosureGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDisclosureGroupView(item: ExerciseDataFields(parent: WorkoutViewModel(), exercise: Exercise(uid: "", name: "Push-ups", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true)))
    }
}

extension ExerciseDisclosureGroupView {
    
    var weightFieldView: some View {
        HStack {
            Text("Weight (lbs):")
            Spacer()
            TextField("", value: $item.weight, formatter: doubleFormatter)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            if viewModel.showPrev && viewModel.prevWeight != nil {
                Text(doubleFormatter.string(from: viewModel.prevWeight! as NSNumber) ?? "0.0")
                    .foregroundColor(Color(.systemGray))
            }
        }
        .font(.title3)
    }
    
    var repsFieldView: some View {
        HStack {
            Text("# of Reps:")
            
            Spacer()
            
            TextField("reps", value: $item.reps, formatter: intFormatter)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            if viewModel.showPrev && viewModel.prevReps != nil {
                Text("\(viewModel.prevReps!)")
                    .foregroundColor(Color(.systemGray))
            }
        }
        .font(.title3)
    }
    
    var timeFieldView: some View {
        HStack {
            Text("Time:")
            
            Text(timeFormatter.string(from: item.time) ?? "0s")
                .foregroundColor(Color(.systemGray))
            
            Button {
                showTimer.toggle()
            } label: {
                Image(systemName: "clock")
            }
            
            Spacer()
            
            if viewModel.showPrev && viewModel.prevTime != nil {
                Text(timeFormatter.string(from: viewModel.prevTime!) ?? "0s")
                    .foregroundColor(Color(.systemGray))
            }
        }
        .font(.title3)
    }
}

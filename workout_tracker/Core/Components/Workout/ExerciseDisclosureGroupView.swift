//
//  ExerciseDisclosureGroupView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import SwiftUI

struct ExerciseDisclosureGroupView: View {
    @State private var showTimer = false
    @State private var showInfo = false
    @State private var isExpanded: Bool = true
    @State var item: ExerciseDataFields
    let onDelete: () -> Void
    
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
    
    init(item: ExerciseDataFields, onDelete: @escaping () -> Void) {
        self.item = item
        self.onDelete = onDelete
    }
    
    // View body
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Divider()
            
            VStack(spacing: 16) {
                HStack(alignment: .top) {
                    //Today stack
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Today")
                            .bold()
                        
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
                    
                    // previous instance stack
                        PreviousInstanceDataView(exercise: item.exercise)
                            .equatable()
                }
                
                // Remove instance from workout
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                }
            }
        } label: {
            HStack {
                Text(item.exercise.name)
                    .bold()
                
                Button {
                    showInfo.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
                Spacer()
                
                // Text("(set 1 of 3)") *Placeholder for potential set count text
            }
            .font(.title2)
        }
        .alert(item.exercise.name,
               isPresented: $showInfo,
                actions: {
                    Button("Close", action: {})
                },
                message: {
                    Text("Notes: \(item.exercise.details)")
        })
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .fullScreenCover(isPresented: $showTimer) {
            print("DEBUG: timer dismissed")
        } content: {
            TimerView(item, title: item.exercise.name)
                .onAppear {
                    // prevent auto-lock while timing an exercise
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
    }
}

struct ExerciseDisclosureGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDisclosureGroupView(item: ExerciseDataFields(parent: WorkoutViewModel(), exercise: Exercise(id: "", uid: "", name: "Push-ups", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true))) {
            print("DEBUG: deleting")
        }
    }
}

extension ExerciseDisclosureGroupView {
    
    var weightFieldView: some View {
        HStack {
            Text("Weight (lbs):")

            TextField("", value: $item.weight, formatter: doubleFormatter)
                .foregroundColor(Color(.systemGray))
                .frame(maxWidth: 80)
            
            Spacer()
        }
        .font(.title3)
    }
    
    var repsFieldView: some View {
        HStack {
            Text("# of Reps:")
            
            TextField("reps", value: $item.reps, formatter: intFormatter)
                .foregroundColor(Color(.systemGray))
                .frame(maxWidth: 80)
            
            Spacer()
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
        }
        .font(.title3)
    }
}

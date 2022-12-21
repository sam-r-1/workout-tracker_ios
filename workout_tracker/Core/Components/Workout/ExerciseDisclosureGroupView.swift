//
//  ExerciseDisclosureGroupView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import SwiftUI

struct ExerciseDisclosureGroupView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.colorScheme) var colorScheme
    @State private var showTimer = false
    @State private var showInfo = false
    @State var isExpanded = false
    @State var item: ExerciseDataFields
    let onDelete: () -> Void
    let iconSize = 20.0

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
                    if item.previousInstance != nil {
                        PreviousInstanceDataView(exercise: item.exercise, previousInstance: item.previousInstance!)
                    }
                }
                
                HStack {
                    Button {
                        showInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    
                    Spacer()
                    
                    Group {
                        if self.item.exercise.includeTime {
                            Button {
                                showTimer.toggle()
                            } label: {
                                Text("Stopwatch")
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Image(systemName: "multiply")
                    }
                }
                .font(.title3)
            }
        } label: {
            HStack {
                Text(item.exercise.name)
                    .bold()
                
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
        .background(Color(colorScheme == .light ? .white : .systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 8)
        .fullScreenCover(isPresented: $showTimer) {
            TimerView(item)
                .onAppear {
                    // prevent auto-lock while timing an exercise
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
        .onAppear(perform: item.fetchPreviousInstance)
    }
}

extension ExerciseDisclosureGroupView {
    var weightFieldView: some View {
        HStack {
            DataFieldIcons.weight
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(Color(.systemGray))

            TextField("0.0", value: $item.weight, formatter: WeightFormatter.weight)
                .frame(maxWidth: sizeCategory.isAccessibilityCategory ? 120 : 70)
                .textFieldStyle(.roundedBorder)
            
            Text("lbs")
            
            Spacer()
        }
        .font(.title3)
    }
    
    var repsFieldView: some View {
        HStack {
            DataFieldIcons.reps
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(Color(.systemGray))
            
            TextField("0", value: $item.reps, formatter: NumberFormatter())
                .frame(maxWidth: sizeCategory.isAccessibilityCategory ? 120 : 70)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
        }
        .font(.title3)
    }
    
    var timeFieldView: some View {
        HStack {
            DataFieldIcons.time
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(Color(.systemGray))
            
            Text(TimeFormatter.durationResult.string(from: item.time ?? 0.0)!)
            
            Spacer()
        }
        .font(.title3)
    }
}

struct ExerciseDisclosureGroupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExerciseDisclosureGroupView(item: ExerciseDataFields(parent: WorkoutViewModel(), exercise: Exercise(id: "", uid: "", name: "Push-ups", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true))) {
                print("DEBUG: deleting")
            }

            ExerciseDisclosureGroupView(item: ExerciseDataFields(parent: WorkoutViewModel(), exercise: Exercise(id: "", uid: "", name: "Push-ups", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true))) {
                print("DEBUG: deleting")
            }
            .environment(\.sizeCategory, .accessibilityLarge)
        }
    }
}

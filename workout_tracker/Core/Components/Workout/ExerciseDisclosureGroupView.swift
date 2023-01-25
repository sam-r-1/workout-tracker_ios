//
//  ExerciseDisclosureGroupView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import SwiftUI
import Firebase

struct ExerciseDisclosureGroupView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.colorScheme) var colorScheme
    @State private var showTimer = false
    @State private var showInfo = false
    @State var item: ExerciseDataFields
    @Binding var isExpanded: Bool
    let onDelete: () -> Void
    @ScaledMetric(relativeTo: .title3) var iconSize: CGFloat = 20.0

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Divider()
            
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    //Today stack
                    VStack(alignment: .leading, spacing: sizeCategory > .extraExtraExtraLarge ? 35 : 6) {
                        Group {
                            Text("Today")
                                .bold()
                            
                            if let prev = self.item.previousInstance {
                                self.sizeCategory.isAccessibilityCategory
                                ? Text(" (prev: \(CustomDateFormatter.shortDateFormatter.string(from: prev.timestamp.dateValue())))")
                                    .foregroundColor(Color(.systemGray))
                                : Text(" (prev: \(CustomDateFormatter.mediumDateFormatter.string(from: prev.timestamp.dateValue())))")
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                        .embedInStack(spacing: 0)
                        
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
                }
                
                HStack {
                    Button {
                        showInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundColor(Color(.systemBlue))
                    
                    Spacer()
                    
                    Group {
                        if self.item.exercise.includeTime {
                            Button {
                                showTimer.toggle()
                            } label: {
                                if self.sizeCategory.isAccessibilityCategory {
                                    Image(systemName: "stopwatch")
                                } else {
                                    Text("Stopwatch")
                                }
                            }
                            .foregroundColor(Color(.systemBlue))
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
                    .foregroundColor(.primary)
                    .strikethrough(item.exerciseCompleted)
                
                if item.exerciseCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(.systemGreen))
                }
                
                Spacer()
                
                // Text("(set 1 of 3)") *Placeholder for potential set count text
            }
            .font(.title3)
        }
        .tint(Color(.systemGray))
        .alert(item.exercise.name,
               isPresented: $showInfo,
                actions: {
                    Button("Close", action: {})
                },
                message: {
                    Text("Notes: \(item.exercise.details)")
        })
        .padding(10)
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
        Group {
            HStack {
                DataFieldIcons.weight
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(Color(.systemGray))
                
                TextField("0.0", value: $item.weight, formatter: WeightFormatter.currentExerciseWeight)
                    .frame(maxWidth: sizeCategory.isAccessibilityCategory ? 120 : 70)
                    .textFieldStyle(.roundedBorder)
                
                Text("lbs")
            }
            
            if let prev = self.item.previousInstance {
                Text(" (\(WeightFormatter.weight.string(from: prev.weight as NSNumber) ?? "0.0"))")
                    .foregroundColor(Color(.systemGray))
            }
        }
        .embedInStack(spacing: 0)
        .font(.title3)
    }
    
    var repsFieldView: some View {
        HStack {
            DataFieldIcons.reps
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(Color(.systemGray))
            
            TextField("0", value: $item.reps, formatter: RepsFormatter.reps)
                .frame(maxWidth: sizeCategory.isAccessibilityCategory ? 120 : 70)
                .textFieldStyle(.roundedBorder)
            
            if let prev = self.item.previousInstance {
                Text(" (\(prev.reps))")
                    .foregroundColor(Color(.systemGray))
            }
            
            Spacer()
        }
        .font(.title3)
    }
    
    var timeFieldView: some View {
        HStack {
            DataFieldIcons.time
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(Color(.systemGray))
            
            Text(TimeFormatter.durationResult.string(from: item.time) ?? "0.0")
            
            if let prev = self.item.previousInstance {
                Text(" (\(TimeFormatter.durationResult.string(from: prev.time) ?? "0s"))")
                    .foregroundColor(Color(.systemGray))
            }
            
            Spacer()
        }
        .font(.title3)
    }
}

struct ExerciseDisclosureGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(1...6, id: \.self) { num in
                        ExerciseDisclosureGroupView(item: ExerciseDataFields(parent: WorkoutViewModel(), exercise: Exercise(id: "", uid: "", name: "Push-ups", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true)), isExpanded: Binding.constant(num == 1 ? true : false)) {
                            print("DEBUG: deleting")
                        }
                    }
                }
            }
            .navigationTitle("My Workout")
        }
    }
}

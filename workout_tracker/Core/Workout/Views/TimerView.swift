//
//  TimerView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var stopwatchManager = StopwatchManager()
    @Environment(\.presentationMode) var presentationMode
    
    let item: ExerciseDataFields
    let setCount: String?
    
    init(_ item: ExerciseDataFields, setCount: String? = nil) {
        self.item = item
        self.setCount = setCount
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray5)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                HStack {
                    Text(self.item.exercise.name)
                        .bold()
                        .font(.title)
                    
                    Text(setCount ?? "")
                        .font(.title)
                }
                .padding(.top)
                
                Spacer()
                
                Text(TimeFormatter.timerFormatter.string(from: stopwatchManager.elapsedTime)!)
                    .bold()
                    .font(.system(size: 80))
                    .scaledToFit()
                
                timerButton

                Spacer()
                
                submitTimeButton
                    .padding(.bottom)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static let previewExercise = Exercise(uid: "", name: "Chest Press", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true)
    
    static var previews: some View {
        TimerView(ExerciseDataFields(parent: WorkoutViewModel(), exercise: previewExercise))
    }
}

extension TimerView {
    
    // Button to start/stop the timer
    var timerButton: some View {
        ZStack {
            
            if stopwatchManager.mode == .paused {
                Button {
                    self.stopwatchManager.start()
                } label: {
                    ZStack {
                        timerButtonBorder
                        
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green)
                        .offset(x: 5, y: 0)
                    }
                }
            } else {
                Button {
                    self.stopwatchManager.pause()
                } label: {
                    ZStack {
                        timerButtonBorder
                        
                        Image(systemName: "stop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
        
    
    // the circular border to be used w/ the timer button
    var timerButtonBorder: some View {
        Circle()
            .stroke(Color.primary, lineWidth: 5)
            .frame(width: 150, height: 150)
    }
    
    
    // If the timer is paused after being allowed to run for some time,
    // present the user with the option to submit or discard the time.
    var submitTimeButton: some View {
        ZStack {
            if stopwatchManager.mode == .paused && stopwatchManager.elapsedTime > 0.0 {
                HStack(spacing: 0) {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("X")
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 155, height: 60)
                            .background(Color(.systemRed))
                    }
                    
                    Button {
                        self.item.time = stopwatchManager.elapsedTime
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 155, height: 60)
                            .background(Color(.systemGreen))
                    }
                }
                .clipShape(Capsule())
            }
            else {
                HStack{}.frame(height: 60)
            }
        }
    }
}

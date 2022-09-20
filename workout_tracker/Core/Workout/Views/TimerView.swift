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
    let formatter: DateComponentsFormatter
    
    @ObservedObject var viewModel: ExerciseInstanceViewModel
    let title: String
    let setCount: String?
    
    init(viewModel: ExerciseInstanceViewModel, title: String, setCount: String? = nil) {
        self.viewModel = viewModel
        self.title = title
        self.setCount = setCount
        
        formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        formatter.allowsFractionalUnits = true
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 50) {
                HStack {
                    Text(title)
                        .bold()
                        .font(.title)
                    
                    Text(setCount ?? "")
                        .font(.title)
                }
                
                Spacer()
                
                Text(formatter.string(from: stopwatchManager.elapsedTime)!)
                    .bold()
                    .font(.system(size: 80))
                    .scaledToFit()
                    .frame(height: 180)
                
                timerButton

                Spacer()
                
                submitTimeButton
            }
            
            Spacer()
        }
        .background(Color(.systemGray5))
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerView(viewModel: ExerciseInstanceViewModel(), title: "Leg Press")
//    }
//}

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
                        viewModel.updateTime(stopwatchManager.elapsedTime)
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

//
//  WorkoutView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import SwiftUI

struct WorkoutView: View {
    @State private var showTimer = false
    @State private var topExpanded: Bool = true
    @State private var reps = ""
    
    var body: some View {
        VStack {
            DisclosureGroup("Leg Press", isExpanded: $topExpanded) {
                HStack {
                    Text("# of Reps")
                    TextField("reps", text: $reps)
                }
                
                HStack {
                    Text("Time")
                    TextField("time", text: $reps)
                    Button {
                        showTimer.toggle()
                    } label: {
                        Text("Timer")
                    }

                }
            }
            .fullScreenCover(isPresented: $showTimer) {
                print("DEBUG: timer dismissed")
            } content: {
                TimerView(title: "Leg Press")
            }
            
            Spacer()
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}

extension WorkoutView {
    
}

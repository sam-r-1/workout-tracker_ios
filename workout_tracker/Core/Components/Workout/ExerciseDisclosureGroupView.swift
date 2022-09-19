//
//  ExerciseDisclosureGroupView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import SwiftUI

struct ExerciseDisclosureGroupView: View {
    @State private var reps = ""
    @State private var showTimer = false
    @State private var isExpanded: Bool = true
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
               
        DisclosureGroup(isExpanded: $isExpanded) {
            Divider()
            
            HStack {
                Text("# of Reps")
                Spacer()
                TextField("reps", text: $reps)
            }
            .font(.title3)
            
            HStack {
                Text("Time")
                TextField(viewModel.formattedTimeString, text: $reps)
                Button {
                    showTimer.toggle()
                } label: {
                    Text("Timer")
                }
            }
            .font(.title3)
        } label: {
            HStack {
                Text("Leg Press")
                    .bold()
                
                Text("(set 1 of 3)")
            }
            .font(.title2)
        }
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .fullScreenCover(isPresented: $showTimer) {
            print("DEBUG: timer dismissed")
        } content: {
            TimerView(viewModel: viewModel, title: "Leg Press")
        }
    }
}

struct ExerciseDisclosureGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDisclosureGroupView(viewModel: WorkoutViewModel())
    }
}

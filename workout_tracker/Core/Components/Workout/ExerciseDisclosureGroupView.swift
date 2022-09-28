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
    @State var item: DataFields
    @ObservedObject var viewModel = ExerciseInstanceViewModel()
    
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
    
    var body: some View {
               
        DisclosureGroup(isExpanded: $isExpanded) {
            Divider()
            
            if item.exercise.includeWeight {
                weightFieldView
            }

            if item.exercise.includeReps {
                repsFieldView
            }

            if item.exercise.includeTime {
                timeFieldView
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
             TimerView(viewModel: viewModel, title: "Leg Press")
        }
    }
}

//struct ExerciseDisclosureGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseDisclosureGroupView(viewModel: ExerciseInstanceViewModel())
//    }
//}

extension ExerciseDisclosureGroupView {
    
    var weightFieldView: some View {
        HStack {
            Text("Weight (lbs):")
            Spacer()
            TextField("", value: $item.weight, formatter: doubleFormatter)
                // .keyboardType(.decimalPad)
                .foregroundColor(Color(.systemGray))
        }
        .font(.title3)
    }
    
    var repsFieldView: some View {
        HStack {
            Text("# of Reps:")
            Spacer()
            TextField("reps", value: $item.reps, formatter: intFormatter)
                .keyboardType(.numberPad)
                .foregroundColor(Color(.systemGray))
        }
        .font(.title3)
    }
    
    var timeFieldView: some View {
        HStack {
            Text("Time:")
            Text("0s")
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            Button {
                showTimer.toggle()
            } label: {
                Text("Timer")
            }
        }
        .font(.title3)
    }
}
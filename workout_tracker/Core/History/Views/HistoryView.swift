//
//  HistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/29/22.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct HistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = ViewModel()
    @State private var historyMode = HistoryMode.workout

    
    enum HistoryMode {
        case workout, exercise
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                Picker("History Mode", selection: $historyMode) {
                    Text("by Workout").tag(HistoryMode.workout)
                    Text("by Exercise").tag(HistoryMode.exercise)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: min(UIScreen.main.bounds.width * 0.8, 400))
                
                switch historyMode {
                    case .workout: HistoryByWorkoutView()
                    case .exercise: HistoryByExerciseView()
                }
            }
            .environmentObject(viewModel)
            .navigationTitle("My History")
            .task {
                await viewModel.fetchUserHistory()
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
        }
    }
}

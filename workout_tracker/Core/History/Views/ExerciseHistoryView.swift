//
//  ExerciseHistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI
import Charts
// import Firebase

struct ExerciseHistoryView: View {
    let exercise: Exercise
    @State private var chartIsExpanded = false
    @StateObject var viewModel = ExerciseResultsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemGray5).edgesIgnoringSafeArea(.all)
                
                Group {
                    if viewModel.exerciseInstances.isEmpty {
                        Text("No data for \(exercise.name)")
                    } else {
                        VStack(spacing: 0) {
                            performanceChart
                                .frame(height: geometry.size.height * (chartIsExpanded ? 1 : 0.35))
                                .rotationEffect(Angle(degrees: chartIsExpanded ? 90 : 0))
                            
                            List {
                                ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                                    ExerciseResultRowView(exercise: self.exercise, instance: instance)
                                        .listRowInsets(EdgeInsets())
                                }
                                .onDelete(perform: viewModel.deleteInstance)
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchInstancesFromIdList(self.exercise.id)
                }
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension ExerciseHistoryView {
    var performanceChart: some View {
        TabView {
            if self.exercise.includeWeight {
                PerformanceChartTileView(title: "Weight", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.weight) })
            }
            
            if self.exercise.includeReps {
                PerformanceChartTileView(title: "Reps", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: Double($0.reps)) })
            }
            
            if self.exercise.includeTime {
                PerformanceChartTileView(title: "Time", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.time) })
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct ExerciseHistoryView_Previews: PreviewProvider {
    static let previewExercise = MockService.sampleExercises[2]

    static var previews: some View {
        NavigationView {
            ExerciseHistoryView(exercise: previewExercise, viewModel: ExerciseResultsViewModel(fromPreview: true))
        }
        .preferredColorScheme(.dark)
    }
}

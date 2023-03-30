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
    @Environment(\.colorScheme) var colorScheme
    let exercise: Exercise
    @StateObject var viewModel = ExerciseResultsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
                
                Group {
                    if viewModel.exerciseInstances.isEmpty {
                        Text("No data for \(exercise.name)")
                    } else {
                        VStack(spacing: 4) {
                            performanceChart
                            
                            List {
                                ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                                    ExerciseResultRowView(exercise: self.exercise, instance: instance)
                                        .listRowInsets(EdgeInsets())
                                }
                                .onDelete { offset in
                                    Task {
                                        await viewModel.deleteInstance(at: offset)
                                    }
                                }
                            }
                            .frame(height: geometry.size.height * 0.65)
                        }
                    }
                }
                .task {
                    await viewModel.fetchInstancesForExercise(self.exercise.id)
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
                PerformanceChartTileView(title: "Weight", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.weight) }, chartFillColor: .purple)
            }
            
            if self.exercise.includeReps {
                PerformanceChartTileView(title: "Reps", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: Double($0.reps)) }, chartFillColor: UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1))
            }
            
            if self.exercise.includeTime {
                PerformanceChartTileView(title: "Time", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.time) }, chartFillColor: .blue)
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct ExerciseHistoryView_Previews: PreviewProvider {
    static let previewExercise = MockService.sampleExercises[2]

    static var previews: some View {
        Group {
            NavigationView {
                ExerciseHistoryView(exercise: previewExercise, viewModel: ExerciseResultsViewModel(fromPreview: true))
            }
            .environment(\.sizeCategory, .extraExtraLarge)

            NavigationView {
                ExerciseHistoryView(exercise: previewExercise, viewModel: ExerciseResultsViewModel(fromPreview: true))
            }
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

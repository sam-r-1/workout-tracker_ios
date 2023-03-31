//
//  ExerciseHistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI
import Charts

struct ExerciseHistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: HistoryView.ViewModel
    let exercise: Exercise
    
    init(exercise: Exercise, viewModel: HistoryView.ViewModel) {
        self.exercise = exercise
        self.viewModel = viewModel
    }
    
    @State private var instancesForThisExercise = [ExerciseInstance]()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
                
                Group {
                    if instancesForThisExercise.isEmpty {
                        Text("No data for \(exercise.name)")
                    } else {
                        VStack(spacing: 4) {
                            performanceChart
                            
                            List {
                                ForEach(instancesForThisExercise, id: \.timestamp) { instance in
                                    ExerciseResultRowView(exercise: self.exercise, instance: instance)
                                        .listRowInsets(EdgeInsets())
                                }
                                .onDelete { offset in
                                    Task {
                                        guard let idToDelete = instancesForThisExercise[offset.first!].id else { return }
                                        self.instancesForThisExercise.remove(atOffsets: offset)
                                        await viewModel.deleteInstance(by: idToDelete)
                                    }
                                }
                            }
                            .frame(height: geometry.size.height * 0.65)
                        }
                    }
                }
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.instancesForThisExercise = viewModel.findInstances(forExercise: self.exercise)
            }
        }
    }
}

extension ExerciseHistoryView {
    var performanceChart: some View {
        TabView {
            if self.exercise.includeWeight {
                PerformanceChartTileView(title: "Weight", entries: instancesForThisExercise.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.weight) }, chartFillColor: .purple)
            }
            
            if self.exercise.includeReps {
                PerformanceChartTileView(title: "Reps", entries: instancesForThisExercise.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: Double($0.reps)) }, chartFillColor: UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1))
            }
            
            if self.exercise.includeTime {
                PerformanceChartTileView(title: "Time", entries: instancesForThisExercise.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.time) }, chartFillColor: .blue)
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
                ExerciseHistoryView(exercise: previewExercise, viewModel: HistoryView.ViewModel())
            }
            .environment(\.sizeCategory, .extraExtraLarge)

            NavigationView {
                ExerciseHistoryView(exercise: previewExercise, viewModel: HistoryView.ViewModel())
            }
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

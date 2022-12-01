//
//  PerformanceChartTileView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/1/22.
//

import SwiftUI
import Charts

struct PerformanceChartTileView: View {
    let title: String
    let entries: [ChartDataEntry]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PerformanceLineChartView(title: title, entries: entries)
            
            HStack {
                Spacer()
                
                Button {
                    print("DEBUG: expanding chart")
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                }
                .foregroundColor(.primary)
                .offset(x: -30, y: -30)

            }
        }
    }
}

struct PerformanceChartTileView_Previews: PreviewProvider {
    static let x = Array<Int>(0..<10)
    static let y: [Double] = [10, 12, 11, 15, 14, 16, 18, 22, 20, 25]
    static let entries = x.map({ ChartDataEntry(x: Double($0), y: y[$0]) })
    
    static var previews: some View {
        Group {
            PerformanceChartTileView(title: MockService.sampleExercises[2].name, entries: entries)
            ExerciseHistoryView(exercise: MockService.sampleExercises[2], viewModel: ExerciseResultsViewModel(fromPreview: true))
        }
    }
}

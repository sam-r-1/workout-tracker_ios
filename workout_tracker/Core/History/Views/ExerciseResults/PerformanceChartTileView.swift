//
//  PerformanceChartTileView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/1/22.
//

import SwiftUI
import Charts

struct PerformanceChartTileView: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let entries: [ChartDataEntry]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            SmallPerformanceLineChart(title: title, entries: entries)
            
            VStack {
                HStack {
                    Text(title)
                        .bold()
                        .font(.title2)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
        }
        .background(colorScheme == .light ? .white : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}

struct PerformanceChartTileView_Previews: PreviewProvider {
    static let x = Array<Int>(0..<10)
    static let y: [Double] = [10, 12, 11, 15, 14, 16, 18, 22, 20, 25]
    static let entries = x.map({ ChartDataEntry(x: Double($0), y: y[$0]) })
    
    static var previews: some View {
        Group {
            PerformanceChartTileView(title: "Weight", entries: entries)
                .frame(height: 275)
            
            NavigationView {
                ExerciseHistoryView(exercise: MockService.sampleExercises[2], viewModel: ExerciseResultsViewModel(fromPreview: true))
            }
            .preferredColorScheme(.dark)
        }
    }
}

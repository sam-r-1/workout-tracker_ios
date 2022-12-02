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
    // @Binding var isExpanded: Bool
    
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
                
//                HStack {
//                    Spacer()
//
//                    Button {
//                        print("DEBUG: expanding chart")
//
//                    } label: {
//                        Image(systemName: "arrow.up.left.and.arrow.down.right")
//                            .resizable()
//                            .scaledToFit()
//                    }
//                    .foregroundColor(.primary)
//                    .frame(width: 20, height: 20)
//                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
        }
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(8)
        // .shadow(radius: 8)
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
        }
    }
}

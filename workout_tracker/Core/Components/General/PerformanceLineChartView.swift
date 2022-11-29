//
//  PerformanceLineChartView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/29/22.
//

import SwiftUI
import Charts

struct PerformanceLineChartView: UIViewRepresentable {
    let entries: [ChartDataEntry]
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        uiView.data = LineChartData(dataSet: dataSet)
    }
}

struct PerformanceLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceLineChartView()
    }
}

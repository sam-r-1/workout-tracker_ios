//
//  PerformanceLineChartView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/29/22.
//

import SwiftUI
import Charts
import Firebase

struct PerformanceLineChartView: UIViewRepresentable {
    var primaryColor: UIColor = .purple
    // var axisLabelColor: UIColor = .black
    
    let entries: [ChartDataEntry]
    let lineChart = LineChartView()
    
    func makeUIView(context: Context) -> LineChartView {
        print("DEBUG: charting \(self.entries.count) points")
        lineChart.delegate = context.coordinator
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.label = "Test Data"
        uiView.noDataText = "No Data"
        uiView.data = LineChartData(dataSet: dataSet)
        uiView.xAxis.enabled = false
        uiView.leftAxis.enabled = false
        uiView.rightAxis.enabled = false
        uiView.legend.enabled = false
//        if uiView.scaleX == 1.0 {
//            uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
//        }
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet, uiView: uiView)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        animateChart(uiView: uiView)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: PerformanceLineChartView
        
        init(parent: PerformanceLineChartView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    private func formatDataSet(dataSet: LineChartDataSet, uiView: LineChartView) {
        dataSet.lineWidth = 1.5
        dataSet.drawCirclesEnabled = false
        dataSet.colors = [primaryColor]
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.1
//        dataSet.valueColors = [primaryColor]
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        // fill
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        let colors = [primaryColor.cgColor, CGColor(red: 255, green: 255, blue: 255, alpha: 1)]
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil) else { return }
        
        dataSet.fill = Fill(linearGradient: gradient, angle: -90)
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(uiView.leftAxis.axisMinimum)
        }
    }
    
    private func formatLeftAxis(leftAxis: YAxis) {
//        leftAxis.labelTextColor = axisLabelColor
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = -10
    }
    
    private func formatXAxis(xAxis: XAxis) {
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
    }
    
    private func formatLegend(legend: Legend) {
//        legend.textColor = axisLabelColor
//        legend.horizontalAlignment = .right
//        legend.verticalAlignment = .top
//        legend.drawInside = true
//        legend.yOffset = 30.0
    }
    
    private func animateChart(uiView: LineChartView) {
        uiView.animate(yAxisDuration: 0.8)
    }
}

extension PerformanceLineChartView {
//    func removeCrowdedXValues(withinPercentage threshold: Double = 0.01) {
//        guard let xMin = entries.first?.x else { return }
//        guard let xMax = entries.last?.x else { return }
//        let testIncrement = (xMax - xMin) * threshold
//
//        var i = 0
//        while i < entries.count {
//            if entries[i].x + testIncrement > entries[i + 1].x {
//                if entries[i].y > entries[i + 1].y {
//                    entries.remove(at: i + 1)
//                } else {
//                    entries.remove(at: i)
//                    i += 1
//                }
//            } else {
//                i += 1
//            }
//        }
//    }
}

struct PerformanceLineChartView_Previews: PreviewProvider {
    static var previewInstances: [ExerciseInstance] {
        let range = 1...15
        return range.map({ ExerciseInstance(uid: "previewUser", exerciseId: "previewExercise", timestamp: Timestamp(date: Date(timeIntervalSinceReferenceDate: Double($0) * 86401.0)), reps: 5, time: 100, weight: Double.random(in: (2 * Double($0) + 80)..<(2 * Double($0) + 120))) })
    }
    
    static var previewEntries: [ChartDataEntry] {
        return previewInstances.map({ ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.weight) })
    }
    
    static var previews: some View {
        PerformanceLineChartView(entries: previewEntries)
            
    }
}

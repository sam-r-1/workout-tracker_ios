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
    var axisLabelColor: UIColor = .black
    
    let entries: [ChartDataEntry]
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
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
        uiView.notifyDataSetChanged()
    }
    
    func formatDataSet(dataSet: LineChartDataSet, uiView: LineChartView) {
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
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil) else {
            return
        }
        
        dataSet.fill = Fill(linearGradient: gradient, angle: -90)
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(uiView.leftAxis.axisMinimum)
        }
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
//        leftAxis.labelTextColor = axisLabelColor
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
    }
    
    func formatLegend(legend: Legend) {
//        legend.textColor = axisLabelColor
//        legend.horizontalAlignment = .right
//        legend.verticalAlignment = .top
//        legend.drawInside = true
//        legend.yOffset = 30.0
    }
}

struct PerformanceLineChartView_Previews: PreviewProvider {
//    static let previewEntries = [
//        ChartDataEntry(x: 1664997398.208757, y: 10),
//        ChartDataEntry(x: 1665002034.381341, y: 14),
//        ChartDataEntry(x: 1665020266.946567, y: 16),
//        ChartDataEntry(x: 1665022611.289474, y: 20),
//        ChartDataEntry(x: 1665022903.760938, y: 21),
//        ChartDataEntry(x: 1665512155.438155, y: 28),
//        ChartDataEntry(x: 1668620700.555461, y: 24),
//        ChartDataEntry(x: 1668624341.671815, y: 31),
//        ChartDataEntry(x: 1668624991.290525, y: 33),
//    ]
    
    static func createPreviewInstance(date: Date, weight: Double) -> ExerciseInstance {
        return ExerciseInstance(uid: "preview", exerciseId: "preview", timestamp: Timestamp(date: date), reps: 5, time: 100, weight: weight)
    }
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

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
    
    let title: String
    let entries: [ChartDataEntry]
    let lineChart = LineChartView()
    
    func makeUIView(context: Context) -> LineChartView {
        lineChart.delegate = context.coordinator
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.label = title
        uiView.noDataText = "No Data"
        uiView.data = LineChartData(dataSet: dataSet)
        uiView.xAxis.enabled = false
        uiView.leftAxis.enabled = false
        uiView.rightAxis.enabled = false
        // uiView.legend.enabled = false
        uiView.highlightPerTapEnabled = false
        uiView.highlightPerDragEnabled = false
//        if uiView.scaleX == 1.0 {
//            uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
//        }
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet, uiView: uiView)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        // animateChart(uiView: uiView)
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
    static let x = Array<Int>(0..<10)
    static let y: [Double] = [10, 12, 11, 15, 14, 16, 18, 22, 20, 25]
    static let entries = x.map({ ChartDataEntry(x: Double($0), y: y[$0]) })
    
    static var previews: some View {
        PerformanceLineChartView(title: "Test", entries: entries)
    }
}

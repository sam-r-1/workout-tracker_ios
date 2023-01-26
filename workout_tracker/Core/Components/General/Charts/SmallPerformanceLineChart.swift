//
//  SmallPerformanceLineChart.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/29/22.
//

import SwiftUI
import Charts
import Firebase

struct SmallPerformanceLineChart: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    let primaryColor: UIColor
    let axisLabelColor: UIColor = .black
    
    let title: String
    let entries: [ChartDataEntry]
    let lineChart = LineChartView()
    
    init(title: String, entries: [ChartDataEntry], withColor primaryColor: UIColor = .purple) {
        self.title = title
        self.entries = entries
        self.primaryColor = primaryColor
        print("DEBUG: " + primaryColor.cgColor.colorSpace.debugDescription)
    }
    
    func makeUIView(context: Context) -> LineChartView {
        lineChart.delegate = context.coordinator
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.label = title
        uiView.minOffset = 0
        uiView.noDataText = "No Data"
        uiView.data = LineChartData(dataSet: dataSet)
        uiView.xAxis.enabled = false
        uiView.leftAxis.enabled = false
        uiView.rightAxis.enabled = false
        uiView.legend.enabled = false
        uiView.highlightPerTapEnabled = false
        uiView.highlightPerDragEnabled = false
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet, uiView: uiView)
        formatXAxis(xAxis: uiView.xAxis)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: SmallPerformanceLineChart
        
        init(parent: SmallPerformanceLineChart) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    private func formatDataSet(dataSet: LineChartDataSet, uiView: LineChartView) {
        dataSet.lineWidth = 2
        dataSet.drawCirclesEnabled = false
        dataSet.colors = [primaryColor]
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.1
        
        // fill
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        let colors = [primaryColor.cgColor, colorScheme == .light ? Color.white.cgColor : UIColor.systemGray6.cgColor]
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil) else { return }
        
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: -90)
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(uiView.leftAxis.axisMinimum)
        }
    }
    
    private func formatXAxis(xAxis: XAxis) {
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
    }
    
    private func animateChart(uiView: LineChartView) {
        uiView.animate(yAxisDuration: 0.8)
    }
}

struct SmallPerformanceLineChart_Previews: PreviewProvider {
    static let x = Array<Int>(0..<10)
    static let y: [Double] = [10, 12, 11, 15, 14, 16, 18, 22, 20, 25]
    static let entries = x.map({ ChartDataEntry(x: Double($0), y: y[$0]) })
    
    static var previews: some View {
            SmallPerformanceLineChart(title: "Test", entries: entries)
                .frame(height: 275)
                .preferredColorScheme(.dark)
    }
}

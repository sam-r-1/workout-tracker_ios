//
//  DetailedPerformanceLineChart.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/2/22.
//

import SwiftUI
import Charts

//TODO: implement this chart
struct DetailedPerformanceLineChart: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    let primaryColor: UIColor = .purple
    let axisLabelColor: UIColor = UIColor(.primary)
    
    let title: String
    let entries: [ChartDataEntry]
    let lineChart = LineChartView()
    @Binding var selectedItem: Int
    
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
        uiView.legend.enabled = false
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet, uiView: uiView)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatRightAxis(rightAxis: uiView.rightAxis)
        formatXAxis(xAxis: uiView.xAxis)
        // animateChart(uiView: uiView)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: DetailedPerformanceLineChart
        
        init(parent: DetailedPerformanceLineChart) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    private func formatDataSet(dataSet: LineChartDataSet, uiView: LineChartView) {
        dataSet.lineWidth = 2
        dataSet.circleColors = [primaryColor]
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 4
        dataSet.colors = [primaryColor]
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.05
        
        // fill
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        let colors = [primaryColor.cgColor, UIColor.systemBackground.cgColor]
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil) else { return }
        
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: -90)
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(uiView.leftAxis.axisMinimum)
        }
    }
    
    private func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = axisLabelColor
        leftAxis.axisLineWidth = 2
    }
    
    private func formatRightAxis(rightAxis: YAxis) {
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisLineWidth = 2
    }
    
    private func formatXAxis(xAxis: XAxis) {
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = true
    }
    
    private func animateChart(uiView: LineChartView) {
        uiView.animate(yAxisDuration: 0.8)
    }
}

struct DetailedPerformanceLineChart_Previews: PreviewProvider {
    static let x = Array<Int>(0..<10)
    static let y: [Double] = [10, 12, 11, 15, 14, 16, 18, 22, 20, 25]
    static let entries = x.map({ ChartDataEntry(x: Double($0), y: y[$0]) })
    
    static var previews: some View {
        Group {
            DetailedPerformanceLineChart(title: "Test", entries: entries, selectedItem: Binding.constant(1))
                .frame(height: 275)
                .previewInterfaceOrientation(.landscapeLeft)
            
            SmallPerformanceLineChart(title: "Test", entries: entries)
                .frame(height: 275)
        }
    }
}

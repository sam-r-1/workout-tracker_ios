//
//  DetailedPerformanceLineChart.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/2/22.
//

import SwiftUI
import Charts
import Firebase

struct DetailedPerformanceLineChart: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    let primaryColor: UIColor = .purple
    let axisLabelColor: UIColor = UIColor(.primary)
    
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
        uiView.minOffset = 0
        uiView.noDataText = "No Data"
        uiView.data = LineChartData(dataSet: dataSet)
        uiView.xAxis.enabled = false
        uiView.rightAxis.enabled = false
        uiView.legend.enabled = false
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet, uiView: uiView)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
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
        //dataSet.drawCirclesEnabled = false
        dataSet.circleColors = [primaryColor]
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 3
        dataSet.colors = [primaryColor]
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.05
//        dataSet.valueColors = [primaryColor]
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        // fill
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        let colors = [primaryColor.cgColor, UIColor.systemBackground.cgColor]
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil) else { return }
        
        dataSet.fill = Fill(linearGradient: gradient, angle: -90)
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(uiView.leftAxis.axisMinimum)
        }
    }
    
    private func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = axisLabelColor
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
    }
    
    private func formatXAxis(xAxis: XAxis) {
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = true
    }
    
    private func formatLegend(legend: Legend) {
//        legend.textColor = axisLabelColor
//        legend.horizontalAlignment = .center
//        legend.verticalAlignment = .bottom
//        legend.drawInside = true
//        legend.yOffset = 30.0
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
            DetailedPerformanceLineChart(title: "Test", entries: entries)
                .frame(height: 275)
                .previewInterfaceOrientation(.landscapeLeft)
            
            SmallPerformanceLineChart(title: "Test", entries: entries)
                .frame(height: 275)
        }
    }
}

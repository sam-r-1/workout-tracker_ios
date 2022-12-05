//
//  FullPerformanceChartView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/2/22.
//

import SwiftUI
import Charts

//TODO: implement this view
struct FullPerformanceChartView: View {
    let title = "Chest Press (Weight)"
    let entries: [ChartDataEntry]
    @State private var currentPlot: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Spacer()
                
                Text(title)
                    .bold()
                    .font(.system(size: 18))
                
                Spacer()
                
            }
            .overlay(alignment: .trailing, content: {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(8)
                        .background(
                            Circle()
                                .foregroundColor(Color(.systemGray5))
                                .opacity(0.7)
                        )
                }
                .foregroundColor(.primary)
                .offset(x: -30)
            }
            )
            .padding(.top, 15)
            
            Spacer()
            
            DetailedPerformanceLineChart(title: "Weight", entries: entries, selectedItem: Binding.constant(0))
                .padding(.horizontal, 10)
            
        }
        .navigationBarHidden(true)
    }
}

struct FullPerformanceChartView_Previews: PreviewProvider {
    static let x = Array<Int>(0..<10)
    static let y: [Double] = [10, 12, 11, 15, 14, 16, 18, 22, 20, 25]
    static let entries = x.map({ ChartDataEntry(x: Double($0), y: y[$0]) })
    
    static var previews: some View {
        FullPerformanceChartView(entries: entries)
            .previewInterfaceOrientation(.portrait)
    }
}
